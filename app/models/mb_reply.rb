class MbReply
	include Mongoid::Document
	field :content
	belongs_to :user, :inverse_of => :mb_replies
end