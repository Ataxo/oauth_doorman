# -*- encoding : utf-8 -*-
require 'pp'
require 'test_helper'

require 'rack/test'
require 'webmock/test_unit'

require 'oauth_doorman/sinatra'

class TestDoormanSinatra < Sinatra::Base

  USERS = ["test@email.com"]

  register Sinatra::DoormanAuth

  #set oauth settings
  set :doorman_client_id, "407096005665.apps.googleusercontent.com"
  set :doorman_client_secret, "z3iVgQHtlFfAoBae5EvrBqe7"
  set :doorman_app_name, "OauthDoormanTest"

  #set urls where to redirect after sign in/out
  set :default_url_after_sign_in, "/protected_page"
  set :default_url_after_sign_out, "/"

  #implement your own method for signing
  # * <string> - email of user who want to be authorized
  def authorize_user email
    if USERS.include?(email)
      @user = email
    else 
      nil
    end
  end
  
  # ADDITIONAL METHODS ONLY FOR TESTING

  #index page
  get "/" do
    "Testing of oauth login <a href='/protected_page'>go to protected page</a> or <a href='/sign_in'>login by google apps</a>"
  end

  #login page
  get "/sign_in" do
    protected
  end

  #protected page :-)
  get "/protected_page" do
    protected
    "You are in protected zone as #{@user} <a href='/sign_out'>You can sign out</a>"
  end 
  
end


class OauthDoormanSinatraTest < Test::Unit::TestCase
  include Rack::Test::Methods
  
  def app
    TestDoormanSinatra.new
  end

  context "Test Doorman Sinatra" do
    context "index" do
      should "responce 200" do
        get '/'
        assert_equal last_response.status, 200
      end
    end

    context "sign in" do
      should "redirect to google" do
        get '/sign_in'
        assert_equal last_response.status, 302
        assert last_response.headers["Location"] =~ /^https:\/\/accounts.google.com\/o\/oauth2\/auth/, "response location should be pointed to google"
      end

      context "and after user grant access" do
        setup do
          stub_request(:post, "https://accounts.google.com/o/oauth2/token").to_return(:status => 200, :body => File.read(File.join(File.dirname(__FILE__),"fixtures/google_returned_token.fake")), :headers => {})
          stub_request(:get, "https://www.googleapis.com/oauth2/v1/userinfo?access_token=ya29.AHES6ZQSzZ7RiwuYztGsj5MWu1234567890765432").to_return(:status => 200, :body => File.read(File.join(File.dirname(__FILE__),"fixtures/google_returned_user_info.fake")), :headers => {})
          stub_request(:get, "https://accounts.google.com/o/oauth2/auth").to_return(:status => 302, :body => "", :headers => {})
        end
        context "redirect to callback url" do
        	should "and authorize user" do
            get '/oauth2callback?code=4/T84m7xugirurL7OooQ7VsMQQHtV2.0iYnVRYND0wROl05ti8ZT3anaaDlcgI'
            assert_equal last_response.status, 302
            assert_equal last_response.headers["Location"], "http://example.org/protected_page"
            get '/protected_page'
            assert_equal last_response.status, 200
        	end

          should "and authorize user and sign out user" do
            get '/oauth2callback?code=4/T84m7xugirurL7OooQ7VsMQQHtV2.0iYnVRYND0wROl05ti8ZT3anaaDlcgI'
            assert_equal last_response.status, 302
            assert_equal last_response.headers["Location"], "http://example.org/protected_page"

            get '/sign_out'
            assert_equal last_response.status, 302, "should be looge out"
            assert_equal last_response.headers["Location"], "http://example.org/"

            get '/protected_page'
            assert_equal last_response.status, 302, "after again accesing protected page after update get redirect to google authorization"
            assert last_response.headers["Location"] =~ /^https:\/\/accounts.google.com\/o\/oauth2\/auth/, "response location should be pointed to google"
          end
        end
      end
    end

    context "go to protected page without sign in" do
      should "redirect to google" do
        get '/protected_page'
        assert_equal last_response.status, 302
        assert last_response.headers["Location"] =~ /^https:\/\/accounts.google.com\/o\/oauth2\/auth/, "response location should be pointed to google"
      end
    end

  end
end