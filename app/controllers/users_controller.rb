# encoding: utf-8

class UsersController < ApplicationController

	def index
		if current_user
		  	@user = current_user
		    @mb_posts = MbPost.includes(:user).where(:user_id.in => current_user.following_ids)
		else
			redirect_to "http://passport.huabid.com/login"
		end
	end

	def new
		params[:user_id] = 104988
		@user = User.find_by(:user_id => params[:user_id])
		if @user
			session[:user_id] = @user._id
			redirect_to users_path
		else
			@user = User.new({:user_id => params[:user_id]})
		end
	end

	def create
		@user = User.new(params.require(:user).permit(:nick_name, :user_id, :description, :photo))
		if @user.save
			session[:user_id] = @user._id
			redirect_to users_path, :notice => ''
		else
			render :action => "new"
		end
	end

	def show
		@user = User.find_by(:_id => params[:id])
		@mb_posts = MbPost.where(:user_id => @user._id)
	end

	def edit
		@user = current_user
	end

	def update
		@user = User.find params[:id]
		raise "只能修改自己的资料" if @user != current_user
		if @user.update_attributes(params.require(:user).permit(:nick_name, :description, :photo))
			session[:user_id] = @user._id
			redirect_to users_path, :notice => ''
		else
			render :action => "edit"
		end
	end

end