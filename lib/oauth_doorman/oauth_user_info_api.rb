# -*- encoding : utf-8 -*-

module OauthDoorman
  module UserInfoAPI
    include Error

    def get_user_email()
      result_hash = get_user_info()

      return result_hash["email"]
    end

    def get_user_info()
      result = nil

      begin
        url = "#{config[:user_info_url]}?access_token=#{access_token}"

        http = HTTPClient.new
        result = http.get(url).body

        process_error(result)
      rescue Exception => exception
        raise exception
      end

      return JSON.parse(result)
    end
  end
end