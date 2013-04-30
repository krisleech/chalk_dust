module ChalkDust
  class Connection < ActiveRecord::Base
    belongs_to :publisher,  :polymorphic => true
    belongs_to :subscriber, :polymorphic => true

    def self.for_publisher(publisher)
      where(:publisher_id => publisher.id,
            :publisher_type => publisher.class.to_s)
    end
  end
end
