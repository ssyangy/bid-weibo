require "paperclip"
require "mongoid_paperclip"
class User
	include Mongoid::Document
	include Mongoid::Paperclip
	field :nick_name, :type => String
	field :user_id,   :type => Integer
	field :description
	field :following_count
	field :followers_count
	has_many :mb_posts
	has_many :mb_replies
	has_and_belongs_to_many :following, :class_name => 'User', :inverse_of => :followers    #关注
    has_and_belongs_to_many :followers, :class_name => 'User', :inverse_of => :following    #粉丝

    validates :user_id, :presence => true, :uniqueness => true
    validates :nick_name, :format => {:with => /\A[\p{Han}\p{Alnum}\-_]{4,24}\z/, :message => '仅支持长度为4-24位的中英文，数字和"_"'}, :presence => true, :uniqueness => true

    has_mongoid_attached_file :photo,
    :styles => {:small => "30x30>",:medium => "96x96>", :thumb => "50x50>",:big => "150x150>"},
    :url => "/system/:attachment/:id/:style/:id.:extension",
    :convert_options => { :all => '-strip' },
    :default_style => :medium
    validates_attachment_content_type :photo, :content_type => /image/
    validates_attachment_size :photo, :less_than => 2.megabyte , :message => "图片不能大于2M"

end