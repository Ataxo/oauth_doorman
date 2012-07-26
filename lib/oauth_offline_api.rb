module OauthDoorman
  class OfflineAPI
    def self.get_access_token(refresh_token, client_id, client_secret)
      hash_params = {}
      hash_params["refresh_token"] = refresh_token
      hash_params["client_id"] = client_id
      hash_params["client_secret"] = client_secret
      hash_params["grant_type"] = "refresh_token"

      result = call_grant_request_token(hash_params)

      json = JSON.parse(result)
      access_token = json['access_token']

      return access_token
    end

    def self.call_grant_request_token(hash_params)
      result = nil

      begin
        hash_params.each_key { |key|
          hash_params[key] = URI.escape(hash_params[key])
        }

        url = "https://accounts.google.com/o/oauth2/token"
        http = HTTPClient.new
        result = http.post(url, hash_params).body
        Error.process_error(result)
      rescue Exception => exception
        raise exception
      end

      return result
    end
  end
end