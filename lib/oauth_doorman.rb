# -*- encoding : utf-8 -*-

require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/hash/indifferent_access'
require 'json'
require 'httpclient'

require 'rubygems'

require "oauth_sender.rb"
require "api/oauth_access_api"
require "api/oauth_user_info_api"
require "oauth_domain_groups_api"

module OauthDoorman 
  class Api
    include OauthSender
    include AccessAPI
    include UserInfoAPI
    include DomainGroupsAPI
    
    attr_accessor :access_token, :refresh_token, :start_time, :expires_in

    DEFAULT_CONFIG =
    {
      :redirect_uri => "http://localhost:3000/oauth2callback",
      :client_id => "393121346607.apps.googleusercontent.com",
      :client_secret => "O1biKD-F1IX9h5t8LNQUFQk7",
      :scopes => ["https://www.googleapis.com/auth/userinfo.email", "https://apps-apis.google.com/a/feeds/groups/"],
      :auth_url => "https://accounts.google.com/o/oauth2/auth",
      :token_url => "https://accounts.google.com/o/oauth2/token",
      :response_type => "code",
      :state => "ATAXO",
      :user_info_url => "https://www.googleapis.com/oauth2/v1/userinfo",
      :groups_info_url => "https://apps-apis.google.com/a/feeds/group/2.0/%s/%s/member",
      :groups_info_auth_header_name => "Authorization",
      :groups_info_auth_header_content => "OAuth %s",
      :groups_info_request_timeout => 5,
    }

    def config= conf
      @config = DEFAULT_CONFIG.merge(conf)
    end

    def config
      return @config ||= DEFAULT_CONFIG
    end

    def access_token
      if(!@access_token)
        raise "call init_connection() in your callback function first before using API methods"
      end

      if(access_token_has_expired)
        if(@refresh_token)
          @access_token = get_access_token_from_refresh_token(@refresh_token)
          return @access_token
        else
          raise "No refresh_token to refresh access_token"
        end
      end

      return @access_token
    end

    def initialize(custom_config = nil)
      if(custom_config)
        self.config = custom_config
      end
    end

    def init_connection_by_code(code)
      init_connection(code, nil)
    end

    def init_connection_by_refresh_token(refresh_token)
      init_connection(nil, refresh_token)
    end

    def remaining_seconds_to_expiration()
      return @expires_in - (Time.now - @start_time)
    end

    private
    def init_connection(code, refresh_token)
      result_hash = nil

      if(code)
        result_hash = get_access_or_request_token(code);

        if(result_hash.keys.include?("refresh_token"))
          @refresh_token = result_hash["refresh_token"]
        end
      end

      if(refresh_token)
        @refresh_token = refresh_token

        result_hash = get_access_token_from_refresh_token(@refresh_token)
      end

      @access_token = result_hash["access_token"]
      @expires_in = result_hash["expires_in"]

      @start_time = Time.now()
    end

    def access_token_has_expired()
      if((Time.now - @start_time) > (@expires_in - 10))
        return true
      end

      return false
    end
  end
end
