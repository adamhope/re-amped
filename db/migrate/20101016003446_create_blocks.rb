class CreateBlocks < ActiveRecord::Migration
  def self.up
    create_table :blocks do |t|
      t.integer, :x
      t.integer, :y
      t.string, :north
      t.string, :east
      t.string, :south
      t.string :west

      t.timestamps
    end
  end

  def self.down
    drop_table :blocks
  end
end
