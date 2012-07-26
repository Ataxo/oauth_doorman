module OauthDoorman
  class DomainGroupsAPI
    def self.get_users_of_groups(access_token, domain, group_ids)
      shared_result = {}
      group_ids.each do |group_id|
        shared_result[group_id] = nil
      end

      group_ids.each do |group_id|
        Thread.new(group_id) do |group|
           get_all_group_memebers(domain, group, access_token, shared_result)
        end
      end

      waint_until_thread_finished(shared_result, 5)

      shared_result.each { |key,value|
        Error.process_error(value[0])
      }

      return shared_result
    end

    private
    def self.get_all_group_memebers(domain, group_id, access_token, shared_result)
      result = nil

      begin
        url = "https://apps-apis.google.com/a/feeds/group/2.0/#{domain}/#{group_id}/member"

        http = HTTPClient.new
        result = http.get(url, :header => {'Authorization' => "OAuth " + access_token}).body
      rescue Exception => exception
        raise exception
      end

      if(Error.is_error(result))
        shared_result[group_id] = [ result ]
      else
        emails = get_user_email_from_xml(result)
        shared_result[group_id] = emails
      end
    end

    def self.get_user_email_from_xml(all_group_members_xml)
      regex = /<apps:property name=\'memberId\' value=\'(.*?)\'\/>/m
      user_emails = all_group_members_xml.scan(regex).flatten

      return user_emails
    end

    def self.waint_until_thread_finished(shared_result, timeout)
      error = true
      limit = 10 * timeout
      1.upto(limit) { |i|
        if(all_groups_checked(shared_result))
          error = false
          break;
        end

        sleep(0.1)
      }

      if(error)
        raise "Groups check timeout"
      end
    end

    def self.all_groups_checked(shared_result)
      shared_result.each { |key,value|
        if(value == nil)
          return false
        end
      }

      return true
    end
  end
end