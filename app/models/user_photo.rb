class UserPhoto
	include Mongoid::Document
	field :url, :type => String
	belongs_to :user, :inverse_of => :user_photos

	attr_accessible :user_id, :user_image, :crop_x, :crop_y, :crop_w, :crop_h
    attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
end