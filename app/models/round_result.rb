class RoundResult
  attr_reader  :target_player_name, :rank 
  attr_accessor :went_fishing, :got_from, :current_player_name, :book_completed, :resulting_cards, :next_player_name
  
  def initialize(next_player_name:, target_player_name:, rank:, got_from:, resulting_cards: [], book_completed: false, current_player_name: )
    @next_player_name = next_player_name
    @target_player_name = target_player_name
    @rank = rank
    @resulting_cards = resulting_cards
    @got_from = got_from 
    @book_completed = book_completed
    @current_player_name = current_player_name
  end

  def book_message(rank, player_name)
    return if !book_completed
    if got_from == 'player'
      book_from_player(player_name)
    else
      book_from_fishing(rank, player_name)
    end
  end

  def book_from_fishing(rank, player_name)
    if player_name == current_player_name
      "You completed a book of #{rank}s!"
    else
      "Oh no! #{current_player_name} completed a book of #{rank}s!"
    end
  end

  def book_from_player(player_name)
    if player_name == current_player_name
      "You completed a book of #{rank}s!"
    else
      "Oh no! #{current_player_name} completed a book of #{rank}s!"
    end
  end

  # current player messages
  def current_player_no_match
    message = []
    message << "#{target_player_name} did not have any #{rank}s" << "You went fishing and got the #{readable_resulting_cards.first}!"
    if book_message(rank, current_player_name) then message << book_message(resulting_cards.first.rank, current_player_name) end
    message << "Turn is over" << "It's #{next_player_name}'s turn"
    message
  end

  def current_player_match_from_fishing
    message = []
    message << "#{target_player_name} did not have any #{rank}s" 
    message << "You went fishing and got the #{readable_resulting_cards.first}!"
    if book_message(rank, current_player_name) then message << book_message(rank, current_player_name) end
    message << "Go Again!"
    message
  end

  def current_player_match_from_player
    message = []
    message << "#{target_player_name} had #{rank}s" 
    if book_message(rank, current_player_name) then message << book_message(rank, current_player_name) end
    message << "Go Again!"
    message
  end

  def current_player_message
    return ["There are no cards left in the deck", "Turn Over"] if resulting_cards.empty?
    if got_from == 'fishing' && resulting_cards.first.rank != rank  
      current_player_no_match
    elsif got_from == 'fishing' && resulting_cards.first.rank == rank
      current_player_match_from_fishing
    elsif got_from == 'player'
      current_player_match_from_player
    end 
  end

  # target player messages
  def target_player_no_match
    message = []
    message << "#{current_player_name} asked you for #{rank}s" << "#{current_player_name} went fish!"
    if book_message(rank, target_player_name) then message << book_message(resulting_cards.first.rank, target_player_name) end
    message << "#{current_player_name}'s turn is over"
    message << "It's #{conditional_turn_output} turn"
    message
  end

  def target_player_match_from_fishing
    message = []
    message << "#{current_player_name} asked you for #{rank}s" << "#{current_player_name} went fish!"
    message <<  "#{current_player_name} got a #{rank}"
    if book_message(rank, target_player_name) then message << book_message(rank, target_player_name) end 
    message << "It's #{next_player_name}'s turn"
    message
  end
  
  def target_player_match_from_player
    message = []
    message << "#{current_player_name} took your #{rank}s"
    if book_message(rank, target_player_name) then message << book_message(rank, target_player_name) end
    message << "It's #{next_player_name}'s turn"
    message
  end

  def target_player_message
    if got_from == 'fishing' && resulting_cards.first.rank != rank  
     target_player_no_match
    elsif got_from == 'fishing' && resulting_cards.first.rank == rank
      target_player_match_from_fishing
    elsif got_from == 'player'
     target_player_match_from_player
    end
  end

  def conditional_turn_output
    next_player_name == target_player_name ? 'Your' : "#{next_player_name}'s"
  end

  def output(player)
    if player.name == current_player_name
      current_player_message
    elsif player.name == target_player_name
      target_player_message
    end
  end

  def readable_resulting_cards
    resulting_cards.map(&:to_s)
  end



  def as_json(*)
    {
      next_player_name: next_player_name,
      target_player_name: target_player_name,
      rank: rank,
      got_from: got_from,
      book_completed: book_completed,
      current_player_name: current_player_name, 
      resulting_cards: resulting_cards
    }
  end

  def self.from_json(json)
    self.new(next_player_name: json['next_player_name'], 
                  target_player_name: json['target_player_name'], rank: json['rank'],
                  got_from: json['got_from'],
                  book_completed: json['book_completed'],
                  current_player_name: json['current_player_name'],
                  resulting_cards: json['resulting_cards'].map { |card| Card.from_json(card)}
                )
  end
  
    
  end