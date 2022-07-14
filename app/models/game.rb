class Game < ApplicationRecord
  has_many :game_users
  has_many :users, through: :game_users
  validates :name, presence: true, uniqueness: true
  VALID_PLAYER_MAX = 10
  VALID_PLAYER_MIN = 2
  validates :player_count, presence: true, 
  comparison: { less_than_or_equal_to: VALID_PLAYER_MAX, greater_than_or_equal_to: VALID_PLAYER_MIN },
  numericality: { only_integer: true }

  def remaining_players 
    player_count - users.length
  end

  def start!
    return false unless player_count == users.length
    update(started_at: DateTime.current)
  end

  def current_player
    users[0]
  end

end