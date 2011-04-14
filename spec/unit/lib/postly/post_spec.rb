require 'helper'

describe Postly::Post do
  include Postly

  before(:all) do
    @primary = Site.find('postertester')
  end

  describe "#all" do
    before(:all) do
      @posts = Post.all(@primary.id)
    end

    it "finds the posts" do
      @posts.should be_an Array
      @posts.each{|p| p.id.should_not be_nil }
    end
  end

  describe "CRUD" do
    before(:all) do
      @post     = Post.create(@primary.id, {:title => 'from postly', :body => 'kittens are rad!'})
      @post_id  = @post.id
    end

    describe "#create" do
      it "creates a post" do
        @post.title.should == 'from postly'
      end
    end

    describe "#save" do 
      it "updates a post" do
        @post.title = 'updated via postly'
        @post.save
        @post.reload.title.should  == 'updated via postly'
      end
    end

    describe "#destroy" do
      it "deletes a post and raises a Connection error when not found" do
        @post.destroy
        lambda {
          Post.find(@primary.id, @post.id)
        }.should raise_error Postly::Connection::ConnectionError
      end
    end

  end
end