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

  create_table :connections, :force => true do |t|
    t.integer :subscriber_id
    t.string  :subscriber_type
    t.integer :publisher_id
    t.string  :publisher_type
    t.timestamps
  end
end
