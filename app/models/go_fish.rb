class GoFish
  LESS_THAN_4_STARTING_HAND = 7
  MORE_THAN_4_STARTING_HAND = 5
  attr_accessor :players, :deck, :started, :books, :current_user_index, 
  :round_result, :history, :next_user_index
  def initialize(players: [], deck: Deck.new, books: [], history: [])
    @players = players
    @deck = deck
    @started = false
    @books = books
    @current_user_index = 0
    @history = history
    @next_user_index = 0
    @book_created = false
  end

  def start
    @deck.shuffle
    deal
    @started = true
  end

  def play_round(rank, target_player)
    turn_player = current_player
    return if target_player === current_player
    taken_cards = target_player.give_cards_by_rank(rank)
    if taken_cards.empty?
      fished_card = player_fishes(rank)

      resulting_cards = [fished_card]
      book_created = book_check(fished_card.rank)
      got_from = 'fishing'
    else
      current_player.take_cards(taken_cards)

      resulting_cards = taken_cards
      book_created = book_check(rank)
      got_from = 'player'
    end

    result = RoundResult.new(
      target_player_name: target_player.name, 
      current_player_name: turn_player.name, 
      next_player_name: current_player.name, 
      rank: rank, 
      resulting_cards: resulting_cards, 
      book_completed: book_created,
      got_from: got_from
    )

    set_history(result)
    post_round_check
  end
  
  def player_fishes(rank)
    card = go_fish
    if !card.nil? && card.rank != rank 
      current_user_index_increment
    elsif card.nil?
      current_user_index_increment
    end 
    card
  end

  def go_fish
    return nil if deck.cards.empty?
    current_player.take_cards(deck.deal)[0]
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
    players[current_user_index]
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

  def current_user_index_increment
    @current_user_index = (current_user_index + 1) % players.count
  end

  def next_user_index_increment
    @next_user_index = (current_user_index + 1) % players.count
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

  def post_round_check
    return if over?
    if current_player.hand.empty? && deck.cards.empty? 
      current_user_index_increment 
    elsif current_player.hand.empty?
      puts 'post_round_check'
      go_fish
    end
  end

  def game_winner
    winner = players.sort { |player| player.book_count}.last
  end

  def next_player
    next_user_index_increment
    players[next_user_index]
  end

  def book_check(rank) 
    current_player.books.include?(rank)
  end

  def as_json(*) 
    {
      players: players.map(&:as_json),
      deck: deck.as_json,
      started: started,
      books: books,
      current_user_index: current_user_index,
      history: history
    }
  end

  def self.from_json(json)
    json_players = json['players'].map { |player| Player.from_json(player) }
    json_deck = Deck.new(json['deck']['cards'].map { |card| Card.from_json(card) })
    json_history = json['history'].map { |result| RoundResult.from_json(result) }
    self.new(players: json_players, deck: json_deck, history: json_history )
  end
end