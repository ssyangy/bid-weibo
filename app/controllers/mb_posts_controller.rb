class MbPostsController < ApplicationController

	def create
		@mb_post = MbPost.new(params.require(:mb_post).permit(:content))
		@mb_post.user_id = current_user.id
		if @mb_post.save
			respond_to  do |format|
      			format.html
      			format.js
    		end
		else
			redirect_to users_path
		end
	end

	def destroy
		@mb_post = MbPost.find(params[:id])
		raise "只能删除自己的文章！" if @mb_post.try(:user) != current_user
		if @mb_post.destroy
			respond_to  do |format|
      			format.html
      			format.js
    		end
    	else
    		redirect_to users_path
		end
	end

	def get_reply
    @user = User.find params[:puid]
    @mb_post = MbPost.find params[:pid]
    @mb_replies = @mb_post.mb_replies
    @mb_reply = MbReply.new
    respond_to do |format|
        format.html { render :partial => "replies" }
    end
  end

end