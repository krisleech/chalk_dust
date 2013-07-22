require 'spec_helper'

describe 'publishing' do
  before(:each) do
    ChalkDust::Connection.delete_all
    ChalkDust::ActivityItem.delete_all
  end

  describe '.publish_event' do
    it 'creates an event for every subscriber' do
      kris    = User.create!
      lindsey = User.create!
      hallie  = User.create!
      post    = Post.create!

      ChalkDust::Connection.create(:subscriber => kris,    :publisher => post)
      ChalkDust::Connection.create(:subscriber => lindsey, :publisher => post)

      activity_items = ChalkDust.publish_event(kris, 'editted', post)

      activity_items.size.should == 2

      activity_item = activity_items.first
      activity_item.performer.should == kris
      activity_item.event.should == 'editted'
      activity_item.target.should == post
      activity_item.owner.should == kris

      activity_item = activity_items.last
      activity_item.performer.should == kris
      activity_item.event.should == 'editted'
      activity_item.target.should == post
      activity_item.owner.should == lindsey
    end

    describe 'options' do
      describe ':root' do
        it 'sets the root object of the target' do
          kris    = User.create!
          lindsey = User.create!
          post    = Post.create!
          comment = Comment.create!(:post => post)

          ChalkDust::Connection.create(:subscriber => lindsey, :publisher => post)

          activity_items = ChalkDust.publish_event(kris, 'added', comment, :root => comment.post)

          activity_items.size.should == 1

          activity_item = activity_items.first
          activity_item.performer.should == kris
          activity_item.event.should == 'added'
          activity_item.target.should == comment
          activity_item.owner.should == lindsey
        end
      end

      describe ':topic' do
        it 'sets the topic' do
          user    = User.create!
          post    = Post.create!

          ChalkDust::Connection.create(:subscriber => user,
                                       :publisher  => post,
                                       :topic      => 'family')

          activity_items = ChalkDust.publish_event(user, 'liked', post, :topic => 'family')

          activity_item = activity_items.first
          activity_item.topic.should == 'family'
        end
      end
    end
    
    describe 'fetching publications' do
      it '.publishes_for returns publications for given subscriber' do
        user = User.create!
        post = Post.create!
  
        ChalkDust::Connection.create!(:subscriber => user, :publisher => post)
  
        ChalkDust.publishes_for(user).should == [post]
      end
    end
    
    # pending 'target root can be set by the `activity_root` method on the target'
  end
end

