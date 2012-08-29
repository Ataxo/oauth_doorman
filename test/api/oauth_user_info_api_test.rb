# -*- encoding : utf-8 -*-

require 'test_helper'

class OauthUserInfoApi_Test < Test::Unit::TestCase
  include OauthDoorman::DomainGroupsAPI

  context "*superclass" do
    setup do
      @doorman = OauthDoorman::Api.new()
    end

    should "*must have defined needed params" do
      assert_respond_to(@doorman, :access_token, nil)
    end
  end
end