module Api
  module V1
    class BaseController < ApplicationController
      before_action :doorkeeper_authorize!
      protect_from_forgery with: :null_session

      respond_to :json

      def current_resource_owner
        @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end
    end
  end
end
