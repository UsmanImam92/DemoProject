class Micropost < ActiveRecord::Base



  # this relation is automatically generated when we
  # run the command : rails generate model Micropost content:text user:references
  # content is a text field
  # user : reference creates the relation b/w User and Micropost
  # due to the use of user:references command.
  belongs_to :user


  # stabby lambda” syntax for an object called a Proc (procedure) or
  # lambda, which is an anonymous function (a function created without
  # a name). The stabby lambda -> takes in a block (Section 4.3.2) and
  # returns a Proc, which can then be evaluated with the call method.
  # To pull them out in reverse order
  default_scope -> { order(created_at: :desc) }

  # to test the presence of the user_id
  validates :user_id, presence: true

  # to test the presence of content and the length of the content
  validates :content, presence: true, length: {maximum: 140}

end
