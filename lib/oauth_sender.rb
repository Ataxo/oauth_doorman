module OauthDoorman
  module OauthSender
    #force_refresh_token flag for refresh_token enforcement
    def compose_authentification_request_url(force_refresh_token)
      hash_params = {}
      hash_params["client_id"] = config[:client_id]
      hash_params["response_type"] = config[:response_type]
      hash_params["redirect_uri"] = config[:redirect_uri]
      hash_params["state"] = config[:state]
      hash_params["scope"] = config[:scopes].join(" ")
      if(force_refresh_token)
        hash_params["access_type"] = "offline"
        hash_params["approval_prompt"] = "force"
      else
        hash_params["approval_prompt"] = "auto"
      end

      return "#{config[:auth_url]}?#{hash_params.to_query}"
    end
  end
end

