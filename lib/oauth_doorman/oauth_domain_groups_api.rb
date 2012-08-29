# -*- encoding : utf-8 -*-

require "nokogiri"

module OauthDoorman
  module DomainGroupsAPI
    include Error

    def get_user_groups(domain, current_user)
      result = nil

      begin
        url = config[:groups_info_url] % [domain, current_user]

        http = HTTPClient.new
        result = http.get(url, :header => {config[:groups_info_auth_header_name] => config[:groups_info_auth_header_content] % [access_token]}).body

        process_error(result)
      rescue Exception => exception
        raise exception
      end

      user_groups = get_user_group_ids_from_xml(result)
      return user_groups
    end

    def get_user_group_ids_from_xml(groups_xml)
      return Nokogiri::XML(groups_xml).xpath('//apps:property[@name="groupId"]').map { |x| x['value'] }
    end
    
  end
end