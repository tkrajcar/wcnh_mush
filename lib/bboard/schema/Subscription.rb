require 'wcnh'

module BBoard
  
  class Subscription
    include Mongoid::Document
    
    field :read_posts, type: Array, :default => []
    
    belongs_to :user, :class_name => "BBoard::User"
    belongs_to :category, :class_name => "BBoard::Category"

    def unread_posts
      posts = []
      self.category.posts.where(:parent_id => nil).each do |post|
        posts << post if self.read_posts.find_index(post.id).nil?
      end
      return posts
    end
    
    def unread_replies
      replies = {}

      self.category.posts.each do |post|
        post_replies = []

        self.category.posts.where(:parent_id => post.id).each do |reply|
          post_replies << reply if self.read_posts.find_index(reply.id).nil?
        end
      
        replies[post.id] = post_replies if post_replies.length > 0
      end

      return replies
    end
  end
  
end
