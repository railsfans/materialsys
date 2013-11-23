class SessionsController < ApplicationController
	layout "login"

def create 
	if user = User.authenticate(params[:username], params[:password]) 
		session[:user_id] = user.id 
		redirect_to root_path, :notice => "Logged in successfully" 
	else 
		flash.now[:alert] = t('Invalid login/password combination') 
		render :action => 'new' 
	end 
end 

def destroy 
	reset_session 
	redirect_to root_path, :notice => "You successfully logged out" 
end 

def new
end 

end
