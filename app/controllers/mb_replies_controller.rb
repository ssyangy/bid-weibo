class MbRepliesController < ApplicationController
	def create
		@mb_reply = MbReply.new(params.require(:mb_reply).permit(:content, :mb_post_id))
		unless params[:old_mb_reply].blank?
			@old_mb_reply = MbReply.find(params[:old_mb_reply]) 
			@mb_reply.talk_ids = @old_mb_reply.talk_ids
		end
		@mb_reply.user_id = current_user.id
		if @mb_reply.save
			respond_to  do |format|
      			format.html
      			format.js
    		end
		else
			redirect_to users_path
		end
	end

	def talk
		@old_mb_reply = MbReply.find(params[:id])
		@mb_post = @old_mb_reply.mb_post
		@user = @old_mb_reply.user
		@mb_reply = MbReply.new
		respond_to  do |format|
      		format.html
      		format.js
    	end
	end

	def conversation
		@mb_reply = MbReply.find params[:id]
		@mb_replies = MbReply.where(:id.in => @mb_reply.talk_ids)
	end
end