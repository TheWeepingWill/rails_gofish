RSpec.describe 'RoundResult' do 

  PLAYER_NAMES = %w( Joe Bill Curt)

  let(:go_fish_not_match) { Card.new('5', 'Spades').to_s }
  let(:go_fish_match) { Card.new('Ace', 'Hearts').to_s }
  describe '#initialize' do 
    it 'returns default and given paramaters' do 
      result = RoundResult.new(requesting_player_name: PLAYER_NAMES.first, target_player_name: PLAYER_NAMES.last, rank: 'A')
      expect(result.requesting_player_name).to eq 'Joe'
      expect(result.target_player_name).to eq 'Curt'
      expect(result.rank).to eq 'A'
      expect(result.went_fishing).to be false
      expect(result.got_match).to be false
      expect(result.book_completed).to be false
      expect(result.resulting_cards).to eq []
      expect(result.target_player_message).to eq []
      expect(result.requesting_player_message).to eq []
      expect(result.all_besides_requesting_player_message).to eq []
    end
  end
  
  describe '#no_match' do 

    it 'sets the requesting player message to the correct value' do 
      result = RoundResult.new(requesting_player_name: PLAYER_NAMES.first, target_player_name: PLAYER_NAMES.last, rank: 'Ace')
      result.went_fishing = true
      result.got_match = false
      result.resulting_cards = go_fish_not_match
      result.current_player = 'Bill'
      result.no_match
      expect(result.requesting_player_message).to eq ["#{PLAYER_NAMES.last} did not have any Aces", "You went fishing and got the 5 of Spades!", "Turn is over", "It's Bill's turn"]
    end

    it 'sets the target player message to the correct value' do 
      result = RoundResult.new(requesting_player_name: PLAYER_NAMES.first, target_player_name: PLAYER_NAMES.last, rank: 'Ace')
      result.went_fishing = true
      result.got_match = false
      result.resulting_cards = go_fish_match
      result.current_player = 'Bill'
      result.no_match
      expect(result.target_player_message).to eq ["Joe asked you for Aces", "Joe went fish!", "Joe's turn is over", "It's Bill's turn" ]
    end
  end

  describe '#match_from_fishing' do 
    it 'sets the messages to the correct values' do 
      result = RoundResult.new(requesting_player_name: PLAYER_NAMES.first, target_player_name: PLAYER_NAMES.last, rank: 'Ace')
      result.went_fishing = true
      result.got_match = true
      result.resulting_cards = go_fish_match
      result.current_player = 'Joe'
      result.match_from_fishing
      expect(result.requesting_player_message).to eq ["#{PLAYER_NAMES.last} did not have any Aces", "You went fishing and got the Ace of Hearts!", "Go Again!"]
      expect(result.target_player_message).to eq ["Joe asked you for Aces", "Joe went fish!", "Joe got a Ace", "It's Joe's turn" ]
    end
  end

  describe '#match_from_request' do 
    it 'sets the messages to the correct values' do 
      result = RoundResult.new(requesting_player_name: PLAYER_NAMES.first, target_player_name: PLAYER_NAMES.last, rank: 'Ace')
      result.got_match = true
      result.resulting_cards = go_fish_match
      result.current_player = 'Joe'
      result.match_from_request
      expect(result.requesting_player_message).to eq ["#{PLAYER_NAMES.last} had Aces", "Go Again!"]
      expect(result.target_player_message).to eq [ "Joe took your Aces", "It's Joe's turn" ]
    end
  end
 
end