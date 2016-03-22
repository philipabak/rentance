module Authorizable
  def self.included(base)
    base.class_eval do
      before_action :authorize

      private

      def authorize; redirect_to admin_login_url  unless session[:administrator_id] end
    end
  end
end
