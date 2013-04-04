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

  def self.subscribe(subscriber, options)
    publisher = options.fetch(:to)
    Connection.create(:subscriber => subscriber, :publisher => publisher)
  end

  def self.subscribers_of(publisher)
    Connection.subscribers_of(publisher)
  end
end
