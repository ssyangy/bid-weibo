class MbReply
	include Mongoid::Document
	include Mongoid::Timestamps
	field :content
	field :talk_ids
	belongs_to :user, :inverse_of => :mb_replies
	belongs_to :mb_post, :counter_cache => true
end