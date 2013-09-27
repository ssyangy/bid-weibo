class MbPost
	include Mongoid::Document
	include Mongoid::Timestamps
	field :title
	field :content
	field :mb_replies_count, :type => Integer, :default => 0
	field :forwards_count, :type => Integer, :default => 0
	field :path_ids, :type => Array, :default => []
	has_many :mb_pictures
	has_many :mb_replies, :dependent => :destroy
	belongs_to :user, :inverse_of => :mb_posts, :counter_cache => true
	index({ mb_replies_count: 1 })

	default_scope desc(:id)

	before_create :set_mentions
	after_create :update_homeline, :set_path_ids

	def update_homeline
		self.user.userline.push(mb_post_ids: self.id)
		Homeline.where(:user_id.in => self.user.follower_ids_include_self).push(mb_post_ids: self.id)
	end

	def set_mentions
		self.content = self.content.gsub(/@([\p{Han}\p{Alnum}\-_]{3,24})/){|a| "<a href='/#{User.find_by(:nick_name => $1).try(:id)}'>@#{$1}</a>"}
		#self.content.scan(/@[\p{Han}\p{Alnum}\-_]{3,24}/).each do |name|
		#end
	end

	def set_path_ids
		MbPost.where(:id.in => self.path_ids).inc(forwards_count: 1)
		self.set(path_ids: self.path_ids.push(self.id).flatten)
	end

	def has_many_path?
		self.path_ids.size > 1
	end

end