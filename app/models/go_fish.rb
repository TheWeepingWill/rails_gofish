require_relative 'deck'
require_relative 'round_result'
require 'pry'
class GoFish
  LESS_THAN_4_STARTING_HAND = 7
  MORE_THAN_4_STARTING_HAND = 5
  attr_accessor :players, :deck, :started, :books, :round, :round_result, :history
  def initialize(players: [], deck: Deck.new, books: [])
    @players = players
    @deck = deck
    @started = false
    @books = books
    @round = 0
    @history = []
  end

  def start
    @deck.shuffle
    deal
    @started = true
  end

  def play_round(rank, target_player)
    # binding.pry
    puts "A round is being played: #{target_player.name} asked for #{rank}"
    return if target_player === current_player
    result = RoundResult.new(target_player_name: target_player.name, rank: rank, requesting_player_name: current_player.name)
    taken_cards = target_player.give_cards_by_rank(rank)
    if taken_cards == []
      result.went_fishing = true
      player_fishes(rank, result)
    else
      puts "#{current_player} got #{target_player.name}'s #{rank}'s"
      current_player.take_cards(taken_cards)
      result.got_match = true
      result.match_from_request
    end
    set_history(result)
    post_round_check(result)
  end
  
  def player_fishes(rank, result)
    card = go_fish(result)
    if !card.nil? && card.rank != rank 
      puts "#{current_player.name} did not get a match from fishing"
      round_increment
      result.current_player = current_player.name
      result.no_match
    elsif card.nil?
      puts "Card was nil"
      round_increment
    else
      puts "#{current_player.name} got a match from fishing"
      result.current_player = current_player.name
      result.got_match = true
      result.match_from_fishing
    end 
  end

  def go_fish(result)
    return nil if deck.cards.empty?
    card = current_player.take_cards(deck.deal)[0]
    result.resulting_cards = card
    card
  end

  def deal
    if players.count > 3 
      MORE_THAN_4_STARTING_HAND.times { players.each {|player| player.take_cards(deck.deal)}}
    else
      LESS_THAN_4_STARTING_HAND.times { players.each {|player| player.take_cards(deck.deal)}}
    end
  end

  def add_player(player)
    return if players.any? { |p| p.name == player.name}
    return if players.count == 2
    players.push(player)
  end

  def empty?
    false
  end

  def current_player
    players[round]
  end

  def ready_to_start?
     players.count == 2 && !started
  end

  def find_player_by_name(player_name)
    players.find { |player| player.name == player_name}
  end

  def all_player_names_but_current 
    players.reject { |player| player.name == current_player.name }.map { |player| player.name }
  end

  def round_increment
    @round = (round + 1) % players.count
  end

  def set_history(result)
    if history.count > players.count 
      @history.shift
      @history.push(result)
    else
      @history.push(result)
    end
  end

  def over?
    players.map { |player| player.books }.flatten.count == 13 
  end

  def post_round_check(result)
    return if over?
    if current_player.hand.empty? && deck.cards.empty? 
      round_increment 
      result.requesting_player_name = current_player.name
      result.no_cards_in_deck
    elsif current_player.hand.empty?
      puts 'post_round_check'
      go_fish(result)
    end
  end

  def game_winner
    winner = players.sort { |player| player.book_count}.last
  end
end