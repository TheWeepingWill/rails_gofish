class Game < ApplicationRecord
  has_many :game_users
  has_many :users, through: :game_users
  belongs_to :winner, class_name: 'User', optional: true, foreign_key: :winner_id
  validates :name, presence: true, uniqueness: true
  VALID_PLAYER_MAX = 10
  VALID_PLAYER_MIN = 2
  validates :player_count, presence: true, 
  comparison: { less_than_or_equal_to: VALID_PLAYER_MAX, greater_than_or_equal_to: VALID_PLAYER_MIN },
  numericality: { only_integer: true }

  serialize :go_fish, GoFish

  def remaining_players 
    player_count - users.length
  end

  def start!
    return false unless player_count == users.length
    
    players = game_users.map { |game_user| Player.new(user_id: game_user.user_id, name: User.find(game_user.user_id).name) }
    go_fish = GoFish.new(players: players)
    go_fish.start
    update(go_fish: go_fish, started_at: DateTime.current)
  end

  def current_player
    User.find_by(name: go_fish.current_player.name)
  end

  def play_round(rank, player_name)
    player = go_fish.find_player_by_name(player_name)
    go_fish.play_round(rank, player)
    check_game_over
    self.save
  end

  def check_game_over
    if go_fish.over?
      finished_at = DateTime.current
      winner_id = go_fish.game_winner.user_id
    end
  end


end