# -*- encoding : utf-8 -*-
class OauthError < Exception; end

module OauthDoorman
  module Error

    def process_error(request_result)
      if request_result == nil
        raise OauthError, "nil response content"
      end

      json = JSON.parse(request_result) rescue nil

      if json && json.has_key?("error")
        raise OauthError, json
      end 
    end

  end
end