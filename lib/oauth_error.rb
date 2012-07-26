module OauthDoorman
  class Error
    def self.is_error(result)
      error_regex = /error/
      return error_regex.match(result)
    end

    def self.process_error(result)
      error_regex = /error/

      if result == nil
        raise "nil request content"
      end

      if(error_regex.match(result))
        raise result
      end
    end
  end
end