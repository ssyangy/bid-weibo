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
		self.user.userline.push(mb_post_ids: self.id)
		Homeline.where(:user_id.in => self.user.follower_ids).push(mb_post_ids: self.id)
	end
end