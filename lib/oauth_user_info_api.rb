module OauthDoorman
  class UserInfoAPI
    def self.get_user_email(acess_token)
      return JSON.parse(get_user_info(acess_token))["email"]
    end

    def self.get_user_info(access_token)
      result = nil

      begin
        url = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=#{access_token}"

        http = HTTPClient.new
        result = http.get(url).body
        Error.process_error(result)
      rescue Exception => exception
        raise exception
      end

      return result
    end
  end
end