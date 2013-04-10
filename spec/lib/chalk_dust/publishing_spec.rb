require 'spec_helper'

describe 'publishing' do
  before(:each) do
    ChalkDust::Connection.delete_all
    ChalkDust::ActivityItem.delete_all
  end

  it '.publish_event creates an event for every subscriber' do
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
end

