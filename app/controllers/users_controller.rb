class UsersController < ApplicationController

	def index
		@user = current_user
		@mb_posts = MbPost.includes(:user).where(:user_id.in => current_user.following_ids)
	end

	def new
		params[:user_id] = 1049
		@user = User.find_by(:user_id => params[:user_id])
		if @user
			session[:user_id] = @user._id
			redirect_to users_path
		else
			@user = User.new({:user_id => params[:user_id]})
		end
	end

	def create
		@user = User.new(params.require(:user).permit(:nick_name, :user_id))
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
end