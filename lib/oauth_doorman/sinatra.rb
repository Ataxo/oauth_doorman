# -*- encoding : utf-8 -*-

require 'sinatra/base'
require 'digest/sha1'

class OauthAuthorizationInvalid < Exception ; end
class OauthAuthorizationError < Exception ; end

module Sinatra
  module DoormanAuth

    module Helpers

      def protected
        redirect doorman_sign_in_url unless session[:email] && authorize_user(session[:email])
      end

      def doorman_sign_in_url
        doorman.compose_authentification_request_url(false)
      end 

      def doorman 
        OauthDoorman::Api.new( 
          redirect_uri: oauth_callback_url, 
          client_id: settings.doorman_client_id, 
          client_secret: settings.doorman_client_secret, 
          state: "Overseer"
        )
      end

      def oauth_callback_url
        "http://#{request.env["HTTP_HOST"]}/oauth2callback"
      end

      def authorize_user email
        raise NoMethodError, "Please implement into your sinatra 'authorize_user' method with one parameter (email). \n Return true if user is known."
      end
    end

    def self.registered(app)
      app.helpers DoormanAuth::Helpers

      app.set :sessions, true
      app.set :session_secret, Digest::SHA1.hexdigest("#{self.class} #{ENV['RACK_ENV']}")

      #Set url to show after logout
      app.set :default_url_after_sign_out, "/"
      #Set url to show after login
      app.set :default_url_after_sign_in, "/"

      # oauth settings
      app.set :doorman_app_name, "#{self.class}"
      app.set :doorman_client_id, "FILL"
      app.set :doorman_client_secret, "FILL"

      app.get "/oauth2callback" do
        door = doorman
        door.init_connection_by_code(request.params["code"])
        user_email = door.get_user_email
        if authorize_user user_email
          session[:email] = user_email
          redirect settings.default_url_after_sign_in
        else
          raise OauthAuthorizationInvalid, "Sorry but your email: #{user_email} is not valid for authorization into #{settings.doorman_app_name}."
        end

        raise OauthAuthorizationError, "Sorry but your attemp to atuhorizate was not succesfull, try again..."
      end

      app.get "/sign_out" do
        session[:email] = nil
        redirect settings.default_url_after_sign_out
      end
    end
  end
end
