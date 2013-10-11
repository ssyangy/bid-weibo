class Userline
	include Mongoid::Document
	include Mongoid::Timestamps
	field :mb_post_ids, :type => Array, :default => []
	belongs_to :user
end