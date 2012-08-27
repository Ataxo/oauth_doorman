require "oauth_error"

module OauthDoorman
  module AccessAPI
    include Error

    #considering force_refresh_token flag of OauthSender redirection (both or access_token only)
    def get_access_or_request_token(code)
      return call_grant_request_token(code, nil)
    end

    def get_access_token_from_refresh_token(refresh_token)
      return call_grant_request_token(nil, refresh_token)
    end

    private
    #returns
    #{
    # "access_token":"1/fFAGRNJru1FTz70BzhT3Zg",
    # "expires_in":3920,
    # "token_type":"Bearer"
    #} if ["authorization_code"] = "refresh_token"
    # or
    #{
    #  "access_token":"1/fFAGRNJru1FTz70BzhT3Zg",
    #  "expires_in":3920,
    #  "token_type":"Bearer",
    #  "refresh_token":"1/xEoDL4iW3cxlI7yDbSRFYNG01kVKM2C-259HOF2aQbI"
    #} if ["authorization_code"] = "authorization_code"
    def call_grant_request_token(code, refresh_token)
      hash_params = {}
      hash_params["client_id"] = config[:client_id]
      hash_params["client_secret"] = config[:client_secret]
      if(refresh_token)
        hash_params["grant_type"] = "refresh_token"
        hash_params["refresh_token"] = refresh_token
      else
        hash_params["code"] = code
        hash_params["grant_type"] = "authorization_code"
        hash_params["redirect_uri"] = config[:redirect_uri]
      end

      result = nil

      begin
        hash_params.each_key { |key|
          hash_params[key] = URI.escape(hash_params[key])
        }

        http = HTTPClient.new
        result = http.post(config[:token_url], hash_params).body

        process_error(result)
      rescue Exception => exception
        raise exception
      end

      return JSON.parse(result)
    end
  end
end