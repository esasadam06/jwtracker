module General
    def try_seperate(token)
        begin
            token_arry = token.split('.')
            decoded = ["",Base64.urlsafe_decode64(token_arry[0]),Base64.urlsafe_decode64(token_arry[1]),token_arry[2]]
            #decoded_payload = Base64.urlsafe_decode64(encoded_payload)
            #decoded_header = Base64.urlsafe_decode64(encoded_header)
        rescue Exception=> exception
            puts token
        ensure
            return decoded
        end
    end
    
    def showtoken(token)
        token_arry = token.split('.')
        decoded = ["",Base64.urlsafe_decode64(token_arry[0]),Base64.urlsafe_decode64(token_arry[1]),token_arry[2]]
        puts "#"*72
        puts "Encoded Header: #{token_arry[1]}"
        puts "Decoded Header: #{decoded[1]}"
        puts "Encoded Payload: #{token_arry[0]}"
        puts "Decoded Payload: #{decoded[2]}"
        puts "Signature: #{token_arry[2]}"
        puts "#"*72
    end
  
    def change(string, old, new)
        return part.gsub(old,new)
    end
  
    def jchange(json)
        temp = JSON.parse(json)
        print "Variable: "
        var = STDIN.gets.chomp
        print "New Value: "
        val = STDIN.gets.chomp
        temp[var] = val
        new_json = temp.to_json
        puts "Old Header: #{json}"
        puts "New Header: #{new_json}"
        return new_json
    end
  
    def kchange(json,key)
        temp = JSON.parse(json)
        print "New value: "
        val = STDIN.gets.chomp
        temp[key] = val
        json = temp.to_json
        puts "New payload: "+json
        return json
    end
  
    def yesorno
        loop do
            temps = STDIN.gets.chomp
            temps = temps.capitalize
            case (temps)
            when "N"
                return false
            when "Y"
                return true
            else
                puts "Please use \"Y/y\" for yes and \"N/n\" for no."
            end
        end
    end
      
    def httpcheck(token)
          newtoken = JSON.parse(token)
          newtoken.each do |key,value|
        if value=~/^http(.*)/
            return value
            end
        end
        return false
    end
      
    def httpvar(token)
        newtoken = JSON.parse(token)
        newtoken.each do |key,value|
        if value=~/^http(.*)/
            return key
            end
        end
        return false
    end
  
    def jwkcheck(token)
        newtoken = JSON.parse(token)
        newtoken.each do |key,value|
        if value=~/json/
            return value
            end
        end
        return false
    end
  
    def wgetjwk(uri)
        res = HTTP.get(uri)
        res = res.body
        return res
    end
  
    def rsacheck(json)
        temp = JSON.parse(json)
        temp.each do |key,value|
        if key=~/key/
            if temp[key][0]["kty"] = "RSA"
                if temp[key][0]["e"] = "AQAB"
                    if temp[key][0]["alg"] = "RS256"
                        puts "***\t Signature Had Beed Created Via a pem File \t*** "
                        puts "Do You Want To Create a New pem File and json Output? Yes[y/Y] - No[n/N] " 
                        condition = yesorno
                        if condition
                            if createpem
                                return true 
                                end
                            end
                        end
                    end
                end
            end
        end
        return false
    end
  
    def createpem()
        begin
            system('openssl genrsa -out private.pem 2048')
            return true
        rescue Exception=>exception
            puts "\t..! pem File Could NOT Been Created !.."
            return false
        end
    end
      
    def getpemrsa()
        begin
            f = OpenSSL::PKey::RSA.new File.read 'private.pem'
            return f
        rescue Exception=>exception
            puts "\t..! pem File Could NOT Been Read"
            return false
        end
    end
      
    def newjwk(old, n, e)
        old.each do |var,val|
        if var=~/key/
            old[var][0]['e']=e
            old[var][0]['n']=n
            puts "***\t\"e\" and \"n\" Have Been Changed Via New Pem File.\t***"
            return old
            end
        end
        puts "***\tUnexpected Error Occure \"e\" and \"n\" Could NOT Changed!\t*** "
    end
  
    def redirectit(value,array)
        flag = false
        array.each do |val|
        begin
            temp = value+""+val
            res = HTTP.get(temp)
            if res.status == 302
                puts "***\tSuccess\t\t***"
                puts "Bypassed with: "+temp
                puts "*** Please modify it on your purpose! ***"
                flag = true
            else
                puts "Failed: "+temp
            end
            rescue Exception=>exception
                puts "  !Exception Occured!  "
                puts " PLEASE CHECK YOUR URL "
            end
        end
        puts " ! Check for False-Positive ! "
        return flag
    end
  
    def singleorlist
        loop do
            temps = STDIN.gets.chomp
            temps = temps.capitalize
            case (temps)
            when "L"
                return false
            when "S"
                return true
            else
                puts "Please use \"S/s\" for Single and \"L/l\" for List."
            end
        end
    end
end