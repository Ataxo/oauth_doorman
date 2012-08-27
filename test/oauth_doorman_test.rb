require 'test_helper'
require File.join(File.dirname(__FILE__), '..', 'lib', 'oauth_doorman')

class OauthDoorman_Test < Test::Unit::TestCase
  context "*new instance" do
    setup do
      @doorman = OauthDoorman::Api.new()
    end

    should "*have valid config params" do
      assert @doorman.config.keys.size > 0, "*config is empty"
      assert @doorman.config.keys.include?(:auth_url), "*misssing :auth_url"
      assert @doorman.config.keys.include?(:token_url), "*misssing :token_url"
      assert @doorman.config.keys.include?(:redirect_uri), "*misssing :redirect_uri"
      assert @doorman.config.keys.include?(:client_id), "*misssing :client_id"
      assert @doorman.config.keys.include?(:scopes), "*misssing :scopes"
      assert @doorman.config.keys.include?(:response_type), "*misssing :response_type"
      assert @doorman.config.keys.include?(:state), "*misssing :state"
      assert @doorman.config.keys.include?(:user_info_url), "*misssing :user_info_url"
      assert @doorman.config.keys.include?(:groups_info_url), "*misssing :groups_info_url"
      assert @doorman.config.keys.include?(:groups_info_auth_header_name), "*misssing :groups_info_auth_header_name"
      assert @doorman.config.keys.include?(:groups_info_auth_header_content), "*misssing :groups_info_auth_header_content"
      assert @doorman.config.keys.include?(:groups_info_request_timeout), "*misssing :groups_info_request_timeout"

      assert_kind_of([].class, @doorman.config[:scopes], nil)
    end
  end

  context "*doorman" do
    setup do
      @doorman = OauthDoorman::Api.new()
    end

    should "*respond_to method" do
      assert_respond_to(@doorman, :compose_authentification_request_url, nil)
      assert_respond_to(@doorman, :get_access_or_request_token, nil)
      assert_respond_to(@doorman, :get_access_token_from_refresh_token, nil)
      assert_respond_to(@doorman, :get_user_info, nil)
      assert_respond_to(@doorman, :get_user_groups, nil)
    end
  end
end

