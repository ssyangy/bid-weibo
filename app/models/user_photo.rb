class UserPhoto
	include Mongoid::Document
	field :url, :type => String
	belongs_to :user, :inverse_of => :user_photos
end