# -*- encoding : utf-8 -*-
# You already have these requires somewhere
require 'sinatra'
require 'sinatra/base'

$LOAD_PATH.unshift( File.expand_path('../../../lib', __FILE__) )

require 'oauth_doorman'
require 'oauth_doorman/sinatra'

# ADD to gemfile if you don't have them
# gem "sinatra"
# gem "sinatra-flash"

class DoormanExampleSinatra < Sinatra::Base

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

USERS = ["test@email.com"]