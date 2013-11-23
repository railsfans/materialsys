class UserController < ApplicationController
skip_before_filter :verify_authenticity_token, :only => [:modify_password, :modify_data]
def modify_password
	flag = false
	if User.authenticate_user(params[:user_id],params[:origin_password])
		flag = true
		@user=User.find(params[:user_id])
		@user.update_attributes(:password=>params[:password], :password_confirmation=>params[:password_confirmation])
	end
	respond_to do |format|
		format.json { render json: { :success=>flag } }
	end
end

def data
	respond_to do |format|
		format.js
	end
end

def add
	respond_to do |format|
		format.js
	end
end
def edit
	respond_to do |format|
		format.js
	end
end

def edit_user
  @user=User.find(params[:user_id])
  respond_to do |format|
    format.json { render json: @user  }
  end
end

def modify_data
  @user=User.find(params[:user_id])
  @user.update_attributes(:username=>params[:username], :email=>params[:email])
  respond_to do |format|
   format.json { render json: { :success=>'success' } }
  end
end

def all
  params[:value]=params[:value] || ''
  if params[:value].empty?
  	@users=User.offset(params[:start].to_i).limit(params[:limit].to_i)
  	totalCount=User.all.count
  else
  	@users=User.where("username like ? or email like ? or role like ? ","%#{params[:value]}%","%#{params[:value]}%","%#{params[:value]}%").offset(params[:start].to_i).limit(params[:limit].to_i)
  	totalCount=@users.count
  end
  respond_to do |format|
   	format.json { render json: { :totalCount=>totalCount, :gridData=>@users }}
  end
end

def user_add
	flag=true
	if params[:role]=='102600'
		role='ordinary'
	else
		role='root'
	end
	if params[:user_role]=='ordinary'  && role == 'root'
		flag=false
	end
	if flag
		@user=User.new
		@user.email=params[:email]
		@user.password=params[:password]
		@user.password_confirmation=params[:password_confirmation]
		@user.role=role
		@user.username=params[:username]
		@user.save
	end
	respond_to do |format|
		format.json { render json: { :success=>flag } }
	end
end

def user_edit
	if params[:role]=='102600'
		role='ordinary'
	else
		role='root'
	end
	@user=User.where(:username=>params[:username]).first
	@user.email=params[:email]
    if params[:password]!=''
	@user.password=params[:password]
	@user.password_confirmation=params[:password_confirmation]
    end
	@user.role=role
	@user.save
	respond_to do |format|
		format.json { render json: { :success=>'success'}}
	end
end

def user_delete
	flag=true
	if User.find(params[:user_id]).username==params[:username]
		flag=false
	end
	if flag
		@user=User.where(:username=>params[:username]).first
		@user.destroy
	end
	respond_to do |format|
		format.json { render json: { :success=>flag} }
	end
end

end
