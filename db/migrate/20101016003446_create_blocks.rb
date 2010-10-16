class CreateBlocks < ActiveRecord::Migration
  def self.up
    create_table :blocks do |t|
      t.integer :user_id
      t.integer :x
      t.integer :y
      t.integer :north
      t.integer :east
      t.integer :south
      t.integer :west

      t.timestamps
    end
  end

  def self.down
    drop_table :blocks
  end
end
