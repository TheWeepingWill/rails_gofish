class Player
  attr_reader :name
  attr_accessor :hand, :books
  def initialize(name: '', hand: [], books: [])
    @name = name
    @hand = hand
    @books = books
  end

  def take_cards(*cards)
    taken_cards = cards.flatten.each { |card| hand.push(card) }
    if hand_count != 0 
      create_books
    else 
      taken_cards
    end
    taken_cards
  end

  def hand_count
    hand.count
  end

  def readable_hand
    hand.map {|card| card.to_s }
  end

  def hand_ranks
    return [] if hand == [nil]
    hand.uniq { |card| card.rank }.map { |card| card.rank }
  end

  def create_books 
    return if !hand_ranks
    hand_ranks = hand.map { |card| card.rank}
    Card::RANKS.each do |rank|
      if hand_ranks.count { |card_rank| rank == card_rank} > 3
        hand.delete_if {|card| card.rank == rank}
        books.push("#{rank}s")
        @books.flatten
      end
    end
  end

  def give_cards_by_rank(rank)
    cards = hand.select {|card| card.rank == rank }
    hand.delete_if {|card| card.rank == rank}
    cards
  end

  def book_count 
    books.count
  end

end