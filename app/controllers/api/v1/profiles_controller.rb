module Api
  module V1
    class ProfilesController < BaseController
      def me
        respond_with current_resource_owner
      end

      def all
        respond_with(@users = User.where.not(id: current_resource_owner.id))
      end
    end
  end
end
