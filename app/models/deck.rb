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

    def as_json(*)
      {
         cards: cards.map(&:as_json)
      }
    end

    def self.from_json(json)
      json_cards = json['cards'].map { |json_card| Card.from_json(json_card) }
      self.new(json_cards)
    end
    
end