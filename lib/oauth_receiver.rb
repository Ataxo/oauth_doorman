module OauthDoorman
  class OauthReceiver
    def self.send_grant_request(request, redirect_uri, client_id, client_secret)
      error = request.params[:error]

      if(error)
        raise error
      end

      #state = request.params[:state]
      code = request.params[:code]

      hash_params = {}
      hash_params["code"] = code
      hash_params["client_id"] = client_id
      hash_params["client_secret"] = client_secret
      hash_params["redirect_uri"] = redirect_uri
      hash_params["grant_type"] = "authorization_code"

      result = OfflineAPI.call_grant_request_token(hash_params)
      json = JSON.parse(result)
      access_token = json['access_token']
      refresh_token = json['refresh_token']

      return access_token, refresh_token
    end
  end
end