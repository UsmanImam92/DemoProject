require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:usman)
    # This code is not idiomatically correct.
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do

    # micropost is valid
    assert @micropost.valid?
  end


    # every micropost must have a user_id as a foreign key
  test "user id should be present" do

    # if user_id is nil then micropost is not valid

    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  # every micropost must be filled with content
  test "content should be present" do

    # if micropost is submitted empty
    # then micropost is not valid
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  # length of micropost must be 140 chars
  test "content should be at most 140 characters" do

    # if length exceeds 140
    # then micropost is not valid
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  # first micropost in the database is the same as a
    # fixture micropost we’ll call most_recent
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end


end
