class User
	include Mongoid::Document
	field :nick_name, :type => String
	field :user_id,   :type => Integer
	field :following_count
	field :followers_count
	has_many :mb_posts
	has_many :mb_replies
	has_many :user_photos
	has_and_belongs_to_many :following, :class_name => 'User', :inverse_of => :followers    #关注
    has_and_belongs_to_many :followers, :class_name => 'User', :inverse_of => :following    #粉丝

    validates :user_id, :presence => true, :uniqueness => true
    validates :nick_name, :format => {:with => /\A[\p{Han}\p{Alnum}\-_]{4,24}\z/, :message => '仅支持长度为4-24位的中英文，数字和"_"'}, :presence => true, :uniqueness => true
end