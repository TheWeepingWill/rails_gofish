class Game < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  VALID_PLAYER_MAX = 10
  validates :player_count, presence: true, comparison: { less_than_or_equal_to: VALID_PLAYER_MAX }

  def remaining_players 
    player_count - user_count
  end
end