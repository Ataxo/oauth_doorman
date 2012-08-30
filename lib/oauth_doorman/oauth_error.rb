# -*- encoding : utf-8 -*-
class OauthError < Exception; end

module OauthDoorman
  module Error
    def is_error(request_result)
      error_regex = /error/
      return error_regex.match(request_result)
    end

    def process_error(request_result)
      
      if request_result == nil
        raise OauthError, "nil response content"
      end

      json = JSON.parse(request_result) rescue nil
      raise OauthError, json if json && json.has_key?("error")

    end
  end
end