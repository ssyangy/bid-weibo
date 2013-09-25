class UsersController < ApplicationController

	def index
		if current_user
		  	@user = current_user
		    @mb_posts = MbPost.includes(:user).where(:id.in => @user.homeline.mb_post_ids).paginate(:page => params[:page], :per_page => 20)
		else
			redirect_to "http://passport.huabid.com/login"
		end
	end

	def new
		params[:user_id] = 1049
		@user = User.find_by(:user_id => params[:user_id])
		if @user
			@user.inc(login_count: 1)
			session[:user_id] = @user.id
			redirect_to users_path
		else
			@user = User.new({:user_id => params[:user_id]})
		end
	end

	def create
		@user = User.new(params.require(:user).permit(:nick_name, :user_id, :description, :photo))
		if @user.save
			@user.inc(login_count: 1)
			session[:user_id] = @user.id
			redirect_to users_path, :notice => ''
		else
			render :action => "new"
		end
	end

	def show
		@user = User.find_by(:_id => params[:id])
		@mb_posts = @user.mb_posts.paginate(:page => params[:page], :per_page => 20)
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

	def myfans
		@users = current_user.followers
	end

	def myfollow
		@users = current_user.followees
	end

	def fans
		@user = User.find(params[:id])
		@users = @user.followers
	end

	def follow
		@user = User.find(params[:id])
		@users = @user.followees
	end

end