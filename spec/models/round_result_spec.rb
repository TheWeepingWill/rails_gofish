require 'rails_helper'
RSpec.describe 'RoundResult' do 

  PLAYER_NAMES = %w( Joe Bill Curt)

  let(:mismatched_card) { Card.new('5', 'Spades')}
  let(:matched_card) { Card.new('Ace', 'Hearts') }
  describe '#initialize' do 
    it 'returns default and given paramaters' do 
      result = RoundResult.new(current_player_name: PLAYER_NAMES.first, 
                              target_player_name: PLAYER_NAMES.last, 
                              rank: 'Ace', 
                              got_from: 'fishing', 
                              resulting_cards: mismatched_card, 
                              book_completed: false,
                              next_player_name: PLAYER_NAMES[1] 
      )

      expect(result.current_player_name).to eq 'Joe'
      expect(result.target_player_name).to eq 'Curt'
      expect(result.rank).to eq 'Ace'
      expect(result.got_from).to eq 'fishing'
      expect(result.book_completed).to be false
      expect(result.resulting_cards).to eq Card.new('5', 'Spades')
      expect(result.next_player_name).to eq 'Bill'
    end
  end
  
  describe '#no_match' do 

    it 'sets the current player message to the correct value' do 
      result = RoundResult.new(current_player_name: PLAYER_NAMES.first, 
        target_player_name: PLAYER_NAMES.last, 
        rank: 'Ace', 
        got_from: 'fishing', 
        resulting_cards: [mismatched_card], 
        book_completed: false,
        next_player_name: PLAYER_NAMES[1] 
      )
      expect(result.output(Player.new(name: PLAYER_NAMES[0]))).to eq ["#{PLAYER_NAMES.last} did not have any Aces", "You went fishing and got the 5 of Spades!", "Turn is over", "It's Bill's turn"]
    end

    it 'sets the target player message to the correct value' do 
      result = RoundResult.new(current_player_name: PLAYER_NAMES.first, 
        target_player_name: PLAYER_NAMES.last, 
        rank: 'Ace', 
        got_from: 'fishing', 
        resulting_cards: [mismatched_card], 
        book_completed: false,
        next_player_name: PLAYER_NAMES[1] 
      )
      expect(result.output(Player.new(name: PLAYER_NAMES.last))).to eq ["Joe asked you for Aces", "Joe went fish!", "Joe's turn is over", "It's Bill's turn" ]
    end
  end

  describe '#match_from_fishing' do 
    it 'sets the messages to the correct values' do 
      result = RoundResult.new(current_player_name: PLAYER_NAMES.first, 
        target_player_name: PLAYER_NAMES.last, 
        rank: 'Ace', 
        got_from: 'fishing', 
        resulting_cards: [matched_card], 
        book_completed: false,
        next_player_name: PLAYER_NAMES[1] 
      )
      expect(result.current_player_message).to eq ["#{PLAYER_NAMES.last} did not have any Aces", "You went fishing and got the Ace of Hearts!", "Go Again!"]
      expect(result.target_player_message).to eq ["Joe asked you for Aces", "Joe went fish!", "Joe got a Ace", "It's Joe's turn" ]
    end
  end

  describe '#match_from_request' do 
    it 'sets the messages to the correct values' do 
      result = RoundResult.new(current_player_name: PLAYER_NAMES.first, 
        target_player_name: PLAYER_NAMES.last, 
        rank: 'Ace', 
        got_from: 'player', 
        resulting_cards: [Card.new('Ace', 'Hearts'), Card.new('Ace', 'Spades')], 
        book_completed: false,
        next_player_name: PLAYER_NAMES[1] 
      )
      expect(result.current_player_message).to eq ["#{PLAYER_NAMES.last} had Aces", "Go Again!"]
      expect(result.target_player_message).to eq [ "Joe took your Aces", "It's Joe's turn" ]
    end
  end

  describe 'books' do 

    it 'tells what book was completed when it got from player' do 
      result = RoundResult.new(current_player_name: PLAYER_NAMES.first, 
        target_player_name: PLAYER_NAMES.last, 
        rank: 'Ace', 
        got_from: 'player', 
        resulting_cards: [Card.new('Ace', 'Hearts'), Card.new('Ace', 'Spades')], 
        book_completed: true,
        next_player_name: PLAYER_NAMES[1] 
      )
      expect(result.output(Player.new(name: PLAYER_NAMES[0]))).to eq ["#{PLAYER_NAMES.last} had Aces", "You completed a book of Aces!", "Go Again!"]
      expect(result.output(Player.new(name: PLAYER_NAMES[2]))).to eq ["Joe took your Aces", "Oh no! Joe completed a book of Aces!", "It's Joe's turn" ]
    end

    it 'tells what book was completed when it got from fishing' do 
      result = RoundResult.new(current_player_name: PLAYER_NAMES.first, 
        target_player_name: PLAYER_NAMES.last, 
        rank: 'Ace', 
        got_from: 'fishing', 
        resulting_cards: [Card.new('Ace', 'Hearts')], 
        book_completed: true,
        next_player_name: PLAYER_NAMES[1] 
      )
      expect(result.output(Player.new(name: PLAYER_NAMES[0]))).to eq ["#{PLAYER_NAMES.last} did not have any Aces", 
                                                        "You went fishing and got the Ace of Hearts!", "You completed a book of Aces!", 
                                                        "Go Again!"]
      expect(result.output(Player.new(name: PLAYER_NAMES[2]))).to eq ["Joe asked you for Aces", "Joe went fish!", "Joe got a Ace", 
                                                                       "Oh no! Joe completed a book of Aces!", "It's Joe's turn" ]
    end

  end

  describe 'json' do
    it 'can turn into json' do 
      result = RoundResult.new(
        current_player_name: PLAYER_NAMES.first,
        target_player_name: PLAYER_NAMES.last,
        rank: 'Ace',
        got_from: 'fishing',
        resulting_cards: mismatched_card,
        book_completed: false,
        next_player_name: PLAYER_NAMES[1]
      )

      json_result = result.as_json

      expect(json_result).to eq({
        current_player_name: PLAYER_NAMES.first,
        target_player_name: PLAYER_NAMES.last,
        rank: 'Ace',
        got_from: 'fishing',
        resulting_cards: mismatched_card,
        book_completed: false,
        next_player_name: PLAYER_NAMES[1]
      })
    end 

    it 'can turn json into an object' do 
      request_payload = {
        'current_player_name' => PLAYER_NAMES.first,
        'target_player_name' => PLAYER_NAMES.last,
        'rank' => 'Ace',
        'got_from' => 'player',
        'resulting_cards' => [matched_card],
        'book_completed' => false,
        'next_player_name' => PLAYER_NAMES[1]
      }
      result = RoundResult.from_json(request_payload)
      expect(result.output(Player.new(name: PLAYER_NAMES.first))).to eq ["#{PLAYER_NAMES.last} had Aces", "Go Again!"]
      expect(result.target_player_message).to eq [ "Joe took your Aces", "It's Joe's turn" ]
    end
  end
 
end