class AddNameIndexToGames < ActiveRecord::Migration[7.0]
  def change
    add_index :games, :name
  end
end
