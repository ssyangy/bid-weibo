class FriendshipsController < ApplicationController
	def create
		@user = User.find params[:uid]
		raise "未找到用户！" if !@user || current_user.follower_of?(@user)
		if current_user.follow(@user)
			current_user.homeline.set(mb_post_ids: current_user.homeline.mb_post_ids + @user.userline.mb_post_ids)
			respond_to  do |format|
      			format.html
      			format.js
    		end
		end
	end

	def destroy
		@user = User.find params[:id]
		raise "未找到用户！" if !@user || current_user.followee_of?(@user)
		if current_user.unfollow(@user)
			current_user.homeline.set(mb_post_ids: current_user.homeline.mb_post_ids - @user.userline.mb_post_ids)
			respond_to  do |format|
      			format.html
      			format.js
    		end
		end
	end
end