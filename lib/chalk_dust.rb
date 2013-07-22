require "chalk_dust/version"
require "chalk_dust/connection"
require "chalk_dust/activity_item"
require "chalk_dust/rails" if defined?(Rails)

module ChalkDust
  def self.subscribe(subscriber, options)
    publisher  = options.fetch(:to)
    undirected = options.fetch(:undirected, false)
    topic      = options.fetch(:topic, blank_topic)

    return if subscribed?(subscriber, :to => publisher, :topic => topic)

    Connection.create(:subscriber => subscriber,
                      :publisher => publisher,
                      :topic => topic)

    Connection.create(:subscriber => publisher,
                      :publisher => subscriber,
                      :topic => topic) if undirected
  end

  def self.unsubscribe(subscriber, options)
    publisher = options.fetch(:from)
    topic     = options.fetch(:topic, blank_topic)
    Connection.delete(:subscriber => subscriber,
                      :publisher  => publisher,
                      :topic      => topic)
  end

  def self.subscribers_of(publisher, options = {})
    topic = options.fetch(:topic, blank_topic)
    Connection.for_publisher(publisher, :topic => topic).map(&:subscriber)
  end

  def self.publishers_of(subscriber)
    Connection.for_subscriber(subscriber).map(&:publisher)
  end
  
  def self.subscribed?(subscriber, options)
    publisher = options.fetch(:to)
    topic     = options.fetch(:topic, blank_topic)
    subscribers_of(publisher, :topic => topic).include?(subscriber)
  end

  def self.self_subscribe(publisher_subscriber)
    subscribe(publisher_subscriber, :to => publisher_subscriber)
  end

  # publishes an event where X (performer) did Y (event) to Z (target) to every
  # subscriber of the target
  def self.publish_event(performer, event, target, options = {})
    root_publisher = options.fetch(:root, target)
    topic          = options.fetch(:topic, blank_topic)
    subscribers_of(root_publisher, :topic => topic).map do |subscriber|
      ActivityItem.create(:performer => performer,
                          :event     => event,
                          :target    => target,
                          :owner     => subscriber,
                          :topic     => topic)
    end
  end

  def self.activity_feed_for(subscriber, options = {})
    topic = options.fetch(:topic, blank_topic)
    activity_items = ActivityItem.for_owner(subscriber)
    activity_items = activity_items.since(options[:since]) if options[:since].present?
    activity_items = activity_items.with_topic(topic) unless topic == :all
    activity_items
  end

  private

  def self.blank_topic
    nil
  end
end
