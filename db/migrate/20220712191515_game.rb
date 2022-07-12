class Game < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.integer :player_count
      t.string :name

      t.timestamps
    end
  end
end
