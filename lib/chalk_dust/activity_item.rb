module ChalkDust
  class ActivityItem < ActiveRecord::Base
    belongs_to :performer, :polymorphic => true
    belongs_to :target,    :polymorphic => true
    belongs_to :owner,     :polymorphic => true

    attr_accessible :publisher, :subscriber

    validates :event, :presence => true

    def self.for_owner(owner)
      where(:owner_id => owner.id,
            :owner_type => owner.class.to_s)
    end

    def self.with_topic(topic)
      where(:topic => topic)
    end

    def self.since(time)
      where("created_at >= ?", time)
    end
  end
end
