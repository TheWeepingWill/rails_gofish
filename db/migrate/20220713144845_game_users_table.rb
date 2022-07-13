class GameUsersTable < ActiveRecord::Migration[7.0]
  def change
    create_table :game_users do |t|
      t.belongs_to :game
      t.belongs_to :user

      t.timestamps
    end
  end
end
