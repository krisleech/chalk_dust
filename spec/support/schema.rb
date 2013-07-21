ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, :force => true do |t|
    t.string  :name
    t.string :email
    t.timestamps
  end

  create_table :posts, :force => true do |t|
    t.string  :title
    t.string :body
    t.timestamps
  end

  create_table :comments, :force => true do |t|
    t.integer :user_id
    t.integer :post_id
    t.string  :body
    t.timestamps
  end

  create_table :connections, :force => true do |t|
    t.integer :subscriber_id
    t.string  :subscriber_type
    t.integer :publisher_id
    t.string  :publisher_type
    t.string  :topic
    t.timestamps
  end

  add_index :connections, [:subscriber_id, :subscriber_type, :publisher_id, :publisher_type, :topic], :unique => true, :name => 'subscriber_publisher_topic'

  create_table :activity_items, :force => true do |t|
    t.integer :performer_id
    t.string  :performer_type

    t.string  :event

    t.integer :target_id
    t.string  :target_type

    t.integer :owner_id
    t.string  :owner_type

    t.string  :topic

    t.timestamps
  end

  add_index :activity_items, [:owner_id, :owner_type, :created_at]
  add_index :activity_items, [:owner_id, :owner_type, :created_at, :topic], :name => 'activity_items_owner_id_type_created_at_topic'
end
