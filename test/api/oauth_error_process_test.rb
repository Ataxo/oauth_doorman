# -*- encoding : utf-8 -*-

require 'test_helper'

class OauthError_Test < Test::Unit::TestCase

  context "Error handling" do 
    setup do
      class TestClass
        include OauthDoorman::Error
      end
      @error = TestClass.new
    end

    should "raise exception when passing JSON with error" do
      assert_raises OauthError do 
        @error.process_error("{ \"error\" : \"invalid request\"}") 
      end
    end

    should "raise exception when passing nil" do
      assert_raises OauthError do 
        @error.process_error(nil) 
      end
    end

    should "not raise exception when passing XML" do
      assert_nothing_raised do 
        @error.process_error("<xml> <description> Some text with error :-) ></description>") 
      end
    end
    
    should "not raise exception when passing JSON" do
      assert_nothing_raised do 
        @error.process_error("{\"message\" : \"JSON message\"}") 
      end
    end

  end
end