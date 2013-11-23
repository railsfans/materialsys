class ApplicationController < ActionController::Base
#  protect_from_forgery
protected

helper_method :current_user
helper_method :logged_in? 

def current_user
	return unless session[:user_id]
	@current_user ||= User.find_by_id(session[:user_id])
end
 
def authenticate
	logged_in? ? true : access_denied
end
 
def logged_in?
	current_user.is_a? User 
end  

def access_denied 
	redirect_to login_path, :notice => t('Please log in to continue') 
	return false 
end 

end
