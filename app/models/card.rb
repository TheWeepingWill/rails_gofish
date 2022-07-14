class Card
  RANKS = %w( 2 3 4 5 6 7 8 9 10 Jack Queen King Ace )
  SUITS = %w( Hearts Spades Clubs Diamonds )
    attr_reader :rank, :suit
    def initialize(rank, suit)
      RANKS.include?(rank) ? @rank = rank : nil
      SUITS.include?(suit) ? @suit = suit : nil
    end
  
    def value 
      RANKS.find_index(rank) + 1
    end
  
    def ==(other)
      return nil if other == nil
      other.rank == self.rank 
    end 
  
    def to_s
      "#{rank} of #{suit}"
    end

    def as_json(*)
      {
        suit: suit,
        rank: rank
      }
    end

    def self.from_json(json)
      self.new(json['rank'], json['suit'])
    end
  end