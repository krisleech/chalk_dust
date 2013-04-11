class ChalkDustCreateTables < ActiveRecord::Migration
  def change
    create_table :connections, :force => true do |t|
      t.integer :subscriber_id
      t.string  :subscriber_type
      t.integer :publisher_id
      t.string  :publisher_type
      t.timestamps
    end

    add_index :connections, [:publisher_id, :publisher_type]

    create_table :activity_items, :force => true do |t|
      t.integer :performer_id
      t.string  :performer_type
      t.string  :event
      t.integer :target_id
      t.string  :target_type
      t.integer :owner_id
      t.string  :owner_type
      t.timestamps
    end

    add_index :activity_items, [:owner_id, :owner_type, :created_at]
  end
end
