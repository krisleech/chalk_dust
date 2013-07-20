module ChalkDust
  class Connection < ActiveRecord::Base
    belongs_to :publisher,  :polymorphic => true
    belongs_to :subscriber, :polymorphic => true

    def self.for_publisher(publisher)
      where(:publisher_id => publisher.id,
            :publisher_type => publisher.class.to_s)
    end

    def self.for_subscriber(subscriber)
      where(:subscriber_id => subscriber.id,
            :subscriber_type => subscriber.class.to_s)
    end
    
    def self.delete(options)
      publisher  = options.fetch(:publisher)
      subscriber = options.fetch(:subscriber)
      topic      = options.fetch(:topic)
      conditions = { :publisher_id    => publisher.id,
                     :publisher_type  => publisher.class.to_s,
                     :subscriber_id   => subscriber.id,
                     :subscriber_type => subscriber.class.to_s }
      conditions = conditions.merge(:topic => topic) unless topic == :all
      destroy_all(conditions)
    end
  end
end
