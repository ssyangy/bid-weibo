class FriendshipsController < ApplicationController
	def create
		@user = User.find params[:uid]
		raise "未找到用户！" if !@user || current_user.follower_of?(@user)
		if current_user.follow!(current_user, @user)
			respond_to  do |format|
      			format.html
      			format.js
    		end
		end
	end

	def destroy
		@user = User.find params[:id]
		raise "未找到用户!" if !@user
		if current_user.unfollow!(current_user, @user)
			respond_to  do |format|
      			format.html
      			format.js
    		end
		end
	end
end