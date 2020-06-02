class ApplicationController < ActionController::Base
	before_action :authenticate_user!
	include Pundit

	# Pundit: white-list approach. Block all that's not allowed.
	after_action :verify_authorized, except: :index, unless: :devise_controller?
	after_action :verify_policy_scoped, only: :index, unless: :devise_controller? 
end
