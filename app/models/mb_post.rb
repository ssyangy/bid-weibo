class MbPost
	include Mongoid::Document
	field :title
	field :content
	field :replies_count, :type => Integer, :default => 0
	field :forwards_count, :type => Integer, :default => 0
	has_many :mb_pictures
	belongs_to :user, :inverse_of => :mb_posts
end