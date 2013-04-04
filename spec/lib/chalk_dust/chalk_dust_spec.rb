require 'spec_helper'

describe ChalkDust do
  before(:each) { ChalkDust::Connection.delete_all }

  describe 'subscribing' do
    it '.subscribe connects two objects' do
      user = User.create!
      post = Post.create!

      ChalkDust.subscribe(user, :to => post)

      connection = ChalkDust::Connection.first
      connection.subscriber.should == user
      connection.publisher.should == post
    end
  end

  describe 'fetching subscriptions' do
    it '.subscriptions_of returns subscribers to given object' do
      user = User.create!
      post = Post.create!

      ChalkDust::Connection.create!(:subscriber => user, :publisher => post)

      ChalkDust.subscribers_of(post).should == [user]
    end
  end
end
