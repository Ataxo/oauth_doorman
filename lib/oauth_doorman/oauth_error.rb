# -*- encoding : utf-8 -*-

module Error
  def is_error(request_result)
    error_regex = /error/
    return error_regex.match(request_result)
  end

  def process_error(request_result)
    error_regex = /error/

    if request_result == nil
      raise "nil response content"
    end

    if(error_regex.match(request_result))
      raise request_result
    end
  end
end