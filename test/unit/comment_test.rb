require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < ActiveSupport::TestCase
  fixtures :users, :posts

  def test_simple
    comment = Comment.create(:post_id => 1, :user_id => 1, :body => "hello world", :ip_addr => "127.0.0.1")
    assert_equal("admin", comment.author)
    assert_equal("hello world", comment.body)
    assert_equal(comment.created_at, Post.find(1).last_commented_at)
  end
  
  def test_no_bump
    comment = Comment.create(:do_not_bump_post => "1", :post_id => 1, :user_id => 1, :body => "hello world", :ip_addr => "127.0.0.1")
    assert_equal("admin", comment.author)
    assert_equal("hello world", comment.body)
    assert_nil(Post.find(1).last_commented_at)
  end

  def test_threshold
    old_threshold = CONFIG["comment_threshold"]
    CONFIG["comment_threshold"] = 1
    
    comment_a = Comment.create(:post_id => 1, :user_id => 1, :body => "mark 1", :ip_addr => "127.0.0.1")
    sleep 2
    comment_b = Comment.create(:post_id => 1, :user_id => 1, :body => "mark 2", :ip_addr => "127.0.0.1")
    assert_equal(comment_a.created_at, Post.find(1).last_commented_at)
    
    CONFIG["comment_threshold"] = old_threshold
  end
  
  def test_api
    comment = Comment.create(:post_id => 1, :user_id => 1, :body => "hello world", :ip_addr => "127.0.0.1")
    comment.to_xml
    comment.to_json
  end
end
