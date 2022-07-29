class AddFinishedAtAndWinnerToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :finished_at, :datetime
    add_reference :games, :winner
  end
end
