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

    it '.self_subscribe connects object to itself' do
      user = User.create!

      ChalkDust.self_subscribe(user)

      connection = ChalkDust::Connection.first
      connection.subscriber.should == user
      connection.publisher.should == user
    end

    describe 'options' do
      it ':undirected subscribes in both directions' do
        bob = User.create!
        alice = User.create!

        ChalkDust.subscribe(bob, :to => alice, :undirected => true)

        ChalkDust::Connection.count.should == 2

        connection_1 = ChalkDust::Connection.first
        connection_1.subscriber.should == bob
        connection_1.publisher.should  == alice

        connection_2 = ChalkDust::Connection.last
        connection_2.subscriber.should == alice
        connection_2.publisher.should  == bob
      end
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

  describe 'querying subscriptions' do
    it '.subscribed? returns true when given object is subscribed to another' do
      user = User.create!
      post = Post.create!

      ChalkDust::Connection.create!(:subscriber => user, :publisher => post)

      ChalkDust.subscribed?(user, :to => post).should be_true
      ChalkDust.subscribed?(post, :to => user).should be_false
    end
  end
end
