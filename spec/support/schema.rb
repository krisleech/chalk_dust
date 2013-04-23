ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, :force => true do |t|
    t.integer :id
    t.string  :name
    t.string :email
    t.timestamps
  end

  create_table :posts, :force => true do |t|
    t.integer :id
    t.string  :title
    t.string :body
    t.timestamps
  end

  create_table :comments, :force => true do |t|
    t.integer :id
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
end
