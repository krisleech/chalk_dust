require 'spec_helper'

describe ChalkDust do
  before(:each) { ChalkDust::Connection.delete_all }

  describe '.unsubscribe' do
    it 'disconnects two objects with no topic' do
      user = User.create!
      post = Post.create!

      with_topic = ChalkDust::Connection.create!(:subscriber => user,
                                                 :publisher  => post,
                                                 :topic      => 'family')

      without_topic = ChalkDust::Connection.create!(:subscriber => user,
                                                    :publisher  => post)

      ChalkDust.unsubscribe(user, :from => post)

      ChalkDust::Connection.all.should == [with_topic]
    end

    describe 'options' do
      it ':topic disconnects only connections with given topic' do
        user = User.create!
        post = Post.create!

        work_topic = ChalkDust::Connection.create!(:subscriber => user,
                                                   :publisher  => post,
                                                   :topic      => 'work')

        family_topic = ChalkDust::Connection.create!(:subscriber => user,
                                                     :publisher  => post,
                                                     :topic      => 'family')

        without_topic = ChalkDust::Connection.create!(:subscriber => user,
                                                      :publisher => post)

        ChalkDust.unsubscribe(user, :from => post, :topic => 'family')

        ChalkDust::Connection.all.should == [work_topic, without_topic]
      end

      it ':topic unsubscribes connections with/out topics when give :all' do
        user = User.create!
        post = Post.create!

        work_topic = ChalkDust::Connection.create!(:subscriber => user,
                                                   :publisher  => post,
                                                   :topic      => 'work')

        family_topic = ChalkDust::Connection.create!(:subscriber => user,
                                                     :publisher  => post,
                                                     :topic      => 'family')

        without_topic = ChalkDust::Connection.create!(:subscriber => user,
                                                      :publisher  => post)

        ChalkDust.unsubscribe(user, :from => post, :topic => :all)

        ChalkDust::Connection.all.should be_empty
      end
    end
  end
end
