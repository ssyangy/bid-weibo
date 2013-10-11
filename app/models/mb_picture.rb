class MbPicture
	include Mongoid::Document
	field :url, :type => String 
	belongs_to :user, :inverse_of => :mb_pictures
end