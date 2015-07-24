module Api
  module V1
    class UsersController < JSONAPI::ResourceController
      # before_filter :restrict_access

      # private
      # def restrict_access
      #   authenticate_or_request_with_http_token do |token, options|
      #     ApiKey.exists?(access_token: token)
      #   end
      # end
    end
  end
end
