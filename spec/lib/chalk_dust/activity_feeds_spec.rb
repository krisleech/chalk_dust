require 'spec_helper'

describe 'activity feeds' do
  before(:each) do
    ChalkDust::ActivityItem.delete_all
  end

  describe '.activity_feed_for' do
    it 'returns activity feed for given object' do
      kris    = User.create!
      lindsey = User.create!
      hallie  = User.create!
      post    = Post.create!
      comment = Comment.create!

      activity_item_1 = ChalkDust::ActivityItem.create(:performer => kris,
                          :event     => 'editted',
                          :target    => post,
                          :owner     => hallie)

      activity_item_2 = ChalkDust::ActivityItem.create(:performer => lindsey,
                          :event     => 'added',
                          :target    => comment,
                          :owner     => hallie)

      activity_items = ChalkDust.activity_feed_for(hallie)
      activity_items.should == [activity_item_1, activity_item_2]
    end

    describe 'options' do
      it ':since limits to activities created since the given date' do
        kris    = User.create!
        lindsey = User.create!
        hallie  = User.create!
        post    = Post.create!
        comment = Comment.create!

        activity_item_1 = ChalkDust::ActivityItem.create(:performer => kris,
                            :event     => 'editted',
                            :target    => post,
                            :owner     => hallie,
                            :created_at => 2.months.ago)

        activity_item_2 = ChalkDust::ActivityItem.create(:performer => lindsey,
                            :event     => 'added',
                            :target    => comment,
                            :owner     => hallie)

        activity_items = ChalkDust.activity_feed_for(hallie, :since => Time.now - 1.week)
        activity_items.should == [activity_item_2]
      end

      it ':topic limits activites to those with given topic' do
        kris    = User.create!
        hallie  = User.create!
        post    = Post.create!

        activity_item_1 = ChalkDust::ActivityItem.create(:performer => kris,
                            :event     => 'editted',
                            :target    => post,
                            :owner     => hallie)

        activity_item_2 = ChalkDust::ActivityItem.create(:performer => kris,
                            :event     => 'liked',
                            :target    => post,
                            :owner     => hallie,
                            :topic     => 'family')

        activity_items = ChalkDust.activity_feed_for(hallie, :topic => 'family')
        activity_items.should == [activity_item_2]
      end
    end
  end
end

