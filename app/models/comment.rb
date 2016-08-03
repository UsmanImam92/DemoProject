class Comment < ActiveRecord::Base
  belongs_to :micropost
  belongs_to :user

  # to test the presence of the user_id
  validates :user_id, presence: true

  # to test the presence of content and the length of the content
  validates :content, presence: true, length: {maximum: 140}

end
