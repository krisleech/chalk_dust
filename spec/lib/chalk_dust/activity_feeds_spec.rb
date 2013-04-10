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
  end
end

