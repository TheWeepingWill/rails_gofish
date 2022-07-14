require_relative 'card'
class Deck
    STANDARD_DECK_LENGTH = Card::RANKS.count * Card::SUITS.count
     attr_accessor :cards
    def initialize(cards = standard_deck)
        @cards = cards

    end

    def standard_deck 
        deck = []
        Card::RANKS.each do |rank|
          Card::SUITS.each do |suit|
          deck.push(Card.new(rank, suit))
          end
        end
        deck 
    end

    def deal 
        cards.shift
    end

    def shuffle
       cards.shuffle!
    end 

    def deck_count 
        cards.count
    end
    
end