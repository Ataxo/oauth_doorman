# -*- encoding : utf-8 -*-

module Error
  def is_error(request_result)
    error_regex = /error/
    return error_regex.match(request_result)
  end

  def process_error(request_result)
    
    if request_result == nil
      raise "nil response content"
    end

    begin 
      json = JSON.parse(request_result)
      if json.has_key?("error")
        raise json
      end
    rescue 
      false
    end
  end
end