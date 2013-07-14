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

    it '.subscribe does not connect subjects multiple times for no topic' do
      user = User.create!
      post = Post.create!

      expect {
        ChalkDust.subscribe(user, :to => post)
        ChalkDust.subscribe(user, :to => post)
      }.to change{ ChalkDust::Connection.count }.by(1)
    end

    it '.subscribe does not connect subjects multiple times for the same topic' do
      user = User.create!
      post = Post.create!

      expect {
        ChalkDust.subscribe(user, :to => post, :topic => 'family')
        ChalkDust.subscribe(user, :to => post, :topic => 'family')
      }.to change{ ChalkDust::Connection.count }.by(1)
    end

    it '.subscribe does connect subjects multiple times for different topics' do
      user = User.create!
      post = Post.create!

      expect {
        ChalkDust.subscribe(user, :to => post, :topic => 'family')
        ChalkDust.subscribe(user, :to => post, :topic => 'work')
      }.to change{ ChalkDust::Connection.count }.by(2)
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

      it ':topic sets the subscription topic' do
        bob = User.create!
        alice = User.create!

        ChalkDust.subscribe(bob, :to => alice, :topic => 'work')

        connection = ChalkDust::Connection.first
        connection.topic.should == 'work'
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
    let(:user) { User.create! }
    let(:post) { Post.create! }

    context 'no connection between subjects' do
      it '.subscribed? returns false when no topic given' do
        ChalkDust.subscribed?(user, :to => post).should be_false
      end

      it '.subscribed? returns false when topic given' do
        ChalkDust.subscribed?(user, :to => post, :topic => 'family').should be_false
      end
    end

    context 'connection between subjects with topic' do
      before { ChalkDust::Connection.create!(:subscriber => user, :publisher => post, :topic => 'family') }

      it '.subscribed? returns true when given topic matches' do
        ChalkDust.subscribed?(user, :to => post, :topic => 'family').should be_true
      end

      it '.subscribed? returns false when no topic given' do
        ChalkDust.subscribed?(user, :to => post).should be_false
      end

      it '.subscribed? returns false when topic does not match' do
        ChalkDust.subscribed?(user, :to => post, :topic => 'work').should be_false
      end
    end

    context 'connection between subjects with no topic' do
      before { ChalkDust::Connection.create!(:subscriber => user, :publisher => post) }

      it '.subscribed? returns true when no topic given' do
        ChalkDust.subscribed?(user, :to => post).should be_true
      end

      it '.subscribed? returns false when topic given' do
        ChalkDust.subscribed?(user, :to => post, :topic => 'family').should be_false
      end
    end
  end
end
