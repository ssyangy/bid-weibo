require "paperclip"
require "mongoid_paperclip"
class User
	include Mongoid::Document
	include Mongoid::Paperclip
	include Mongoid::Timestamps
	#include Mongo::Followable::Followed
    #include Mongo::Followable::Follower
	field :nick_name, :type => String
	field :user_id,   :type => Integer
	field :description
    field :login_count, :type => Integer, :default => 0
	field :followees_count, :type => Integer, :default => 0
	field :followers_count, :type => Integer, :default => 0
    field :mb_posts_count, :type => Integer, :default => 0
	has_many :mb_posts
	has_many :mb_replies
	has_one :homeline
    has_one :userline
	has_and_belongs_to_many :followees, :class_name => 'User', :inverse_of => :followers    #关注
    has_and_belongs_to_many :followers, :class_name => 'User', :inverse_of => :followees    #粉丝

    validates :user_id, :presence => true, :uniqueness => true
    validates :nick_name, :format => {:with => /\A[\p{Han}\p{Alnum}\-_]{3,24}\z/, :message => '仅支持长度为3-24位的中英文，数字和"_"'}, :presence => true, :uniqueness => true

    has_mongoid_attached_file :photo,
    :styles => {:small => "30x30>",:medium => "96x96>", :thumb => "50x50>",:big => "150x150>"},
    :url => "/system/:attachment/:id/:style/:id.:extension",
    :convert_options => { :all => '-strip' },
    :default_style => :medium
    validates_attachment_content_type :photo, :content_type => /image/
    validates_attachment_size :photo, :less_than => 2.megabyte , :message => "图片不能大于2M"

    after_create :create_timeline

    def create_timeline
    	self.build_homeline.save unless self.homeline
        self.build_userline.save unless self.userline
    end

    def follow!(current,user)
        user.followers.push(current)
        user.inc(followers_count: 1)
        current.inc(followees_count: 1)
        current.homeline.set(mb_post_ids: current.homeline.mb_post_ids + user.userline.mb_post_ids)
    end

    def unfollow!(current,user)
        user.followers.delete(current)
        user.inc(followers_count: -1)
        current.inc(followees_count: -1)
        current.homeline.set(mb_post_ids: current.homeline.mb_post_ids - user.userline.mb_post_ids)
    end

    def follower_ids_include_self
        self.follower_ids.insert(0,self.id)
    end

    def follower_of?(user)
        self.followee_ids.include?(user.id)
    end

    def followee_of?(user)
        self.follower_ids.include?(user.id)
    end

end