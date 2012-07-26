module OauthDoorman
  class OauthSender
    def self.compose_authentification_request_url(client_id, redirect_uri, scopes, include_offline)
      hash_params = {}
      hash_params["client_id"] = client_id
      hash_params["response_type"] = "code"
      hash_params["redirect_uri"] = redirect_uri
      hash_params["approval_prompt"] = include_offline ? "force" : "auto"
      hash_params["state"] = "ATAXO"
      hash_params["scope"] = scopes.join(" ")
      if(include_offline)
         hash_params["access_type"]="offline"
      end

      return compose(hash_params)
    end

    private
    def self.compose(hash_params)
      return "https://accounts.google.com/o/oauth2/auth" + "?" + hash_params.to_query
    end
  end
end