require File.join(File.dirname(__FILE__), '..', 'test_helper.rb')
require File.join(File.dirname(__FILE__), '..', '..', 'lib/api', 'oauth_domain_groups_api')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'oauth_doorman')

class OauthDomainGroupsApi_Test < Test::Unit::TestCase
  include OauthDoorman::DomainGroupsAPI

  context "*superclass" do
    setup do
      @doorman = OauthDoorman::Api.new()
    end

    should "*must have defined needed params" do
      assert_respond_to(@doorman, :access_token, nil)
    end
  end

  context "*get_user_group_ids_from_xml" do
    should "*return valid output" do
      xml = File.read( File.join(File.dirname(__FILE__), '..', 'fixtures', 'google_groups_for_user.xml') )
      result = get_user_group_ids_from_xml(xml)
      assert_equal(result, ["rosmarin@ataxo.com", "team@ataxo.com", "team-tg@ataxo.com", "all-cz@ataxo.com", "anglictina@ataxo.com"])
    end
  end
end

