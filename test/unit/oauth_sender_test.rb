require 'test_helper'

class Oauth_Sender_Test < Test::Unit::TestCase

  context "authentication request" do

    context "without any params" do

      should "raise error" do
        assert_raise ArgumentError do
          OauthDoorman::OauthSender.compose_authentification_request_url()
        end
      end

    end

  end

end
