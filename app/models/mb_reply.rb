class MbReply
	include Mongoid::Document
	include Mongoid::Timestamps
	field :content
	field :talk_ids, :type => Array, :default => []
	belongs_to :user, :inverse_of => :mb_replies
	belongs_to :mb_post, :counter_cache => true
	default_scope desc(:id)
	after_create :set_talk_id

	def set_talk_id
		self.set(talk_ids: self.talk_ids.push(self.id).flatten)
	end

	def can_read_conversation?
		self.talk_ids.length > 1
	end
end