require "chalk_dust/version"

module ChalkDust
  class Connection < ActiveRecord::Base
    belongs_to :publisher,  :polymorphic => true
    belongs_to :subscriber, :polymorphic => true

    def self.subscribers_of(publisher)
      where(:publisher_id => publisher.id,
            :publisher_type => publisher.class.to_s).map(&:subscriber)
    end
  end

  class ActivityItem < ActiveRecord::Base
    belongs_to :performer, :polymorphic => true
    belongs_to :target,    :polymorphic => true
    belongs_to :owner,     :polymorphic => true

    validates :event, :presence => true
  end

  def self.subscribe(subscriber, options)
    publisher  = options.fetch(:to)
    undirected = options.fetch(:undirected, false)
    Connection.create(:subscriber => subscriber, :publisher => publisher)
    Connection.create(:subscriber => publisher,  :publisher => subscriber) if undirected
  end

  def self.subscribers_of(publisher)
    Connection.subscribers_of(publisher)
  end

  def self.self_subscribe(publisher_subscriber)
    subscribe(publisher_subscriber, :to => publisher_subscriber)
  end

  # publishes an event where X (performer) did Y (event) to Z (target) to every
  # subscriber of the target
  def self.publish_event(performer, event, target)
    subscribers_of(target).map do |subscriber|
      ActivityItem.create(:performer => performer,
                          :event     => event,
                          :target    => target,
                          :owner     => subscriber)
    end
  end
end
