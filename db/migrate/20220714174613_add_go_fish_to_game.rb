class AddGoFishToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :go_fish, :jsonb
  end
end
