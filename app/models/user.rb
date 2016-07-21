class User < ActiveRecord::Base

  # the belongs_to relation is automatically generated on the migration command.(microposts model)
  # However has_many etc. relations must be manually defined.
  # child relation dependency is created automatically. Parent relation with
  # the child must be declared in the parent model. as done below
  # Here the option dependent: :destroy arranges for the dependent
  # microposts to be destroyed when the user itself is destroyed.
  # This prevents userless microposts from being stranded in the
  # database when admins choose to remove users from the system.
  has_many :microposts , dependent: :destroy


  has_many :comments , dependent: :destroy


  # the user following another user is now identified with the foreign
  # key follower_id, so we have to tell that to Rails.
  # Since destroying a user should also destroy that user’s
  # relationships, we’ve added dependent: :destroy to the association

  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy


  # the information needed to extract an array of followers is
  # already present in the relationships table (which we are
  # treating as the active_relationships table). the technique
  # is exactly the same as for followed users, with the roles of
  # follower_id and followed_id reversed,and with passive_relationships
  # in place of active_relationships.

  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy



  # By default, in a has_many :through association Rails looks for a
  # foreign key corresponding to the singular version of the association.
  # Rails would see “followeds” and use the singular “followed”, assembling
  # a collection using the followed_id in the relationships table.
  # But user.followeds is rather awkward, so we’ll write user.following
  # instead. Naturally, Rails allows us to override the default,
  # in this case using the source parameter, which explicitly tells
  # Rails that the source of the following array is the set of
  # followed ids.
  # The association defined below leads to a powerful combination of Active Record
  # and array-like behavior.


  has_many :following, through: :active_relationships, source: :followed

  #  noting that we could actually omit the :source key for followers.
  # because, in the case of a :followers attribute, Rails will singularize
  # “followers” and automatically look for the foreign key follower_id in this case
  has_many :followers, through: :passive_relationships




  attr_accessor :remember_token
  before_save { email.downcase! }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  validates :about_me, presence: true, length: {minimum: 10}

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

    # Returns a random token.
  def User.new_token
      SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns a random token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end


  # Defines a proto-feed.
  # See "Following users" for the full implementation.
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end


  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end



  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

end



