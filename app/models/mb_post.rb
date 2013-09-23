class MbPost
	include Mongoid::Document
	include Mongoid::Timestamps
	field :title
	field :content
	field :mb_replies_count, :type => Integer, :default => 0
	field :forwards_count, :type => Integer, :default => 0
	has_many :mb_pictures
	has_many :mb_replies, :dependent => :destroy
	has_many :forwards, :class_name => "MbPost", :inverse_of => :forward
	belongs_to :forward, :class_name => "MbPost", :inverse_of => :forwards
	belongs_to :user, :inverse_of => :mb_posts
	index({ mb_replies_count: 1 })

	default_scope desc(:id)

	after_create :update_homeline

	def update_homeline
		users = self.user.all_followers << self.user
		users.each do |follower|
      		follower.homeline.mb_post_ids << self.id
      		follower.homeline.save
    	end
	end
end