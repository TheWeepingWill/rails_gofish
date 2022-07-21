require 'rails_helper'
RSpec.describe Player do 

  describe '#initialize' do 
    it 'creates an object without paramaters' do 
      player = Player.new
      expect(player.name).to eq ''
      expect(player.hand).to eq []
      expect(player.user_id).to be_nil
    end

    it 'creates an object with paramaters' do 
      player = Player.new(name: 'Sydney', user_id: 1)
      expect(player.name).to eq 'Sydney'
      expect(player.hand).to eq []
    end
  end

  it 'can retrieve a list of ranks' do 
    player = Player.new(name: 'Sydney', hand: [Card.new('Ace', 'Spades'), Card.new('Ace', 'Hearts'), Card.new('Jack', 'Spades'), Card.new('3', 'Spades')], user_id: 1)
    expect(player.hand_ranks).to eq (['Ace', 'Jack', '3'])
  end

  it 'counts books' do 
    player = Player.new(name: 'Sydney', hand: [Card.new('Ace', 'Spades'), Card.new('Ace', 'Hearts'), Card.new('Ace', 'Clubs'), Card.new('3', 'Spades')], user_id: 1)
    player.take_cards(Card.new('Ace', 'Diamonds'))
    expect(player.hand_count).to eq 1
    expect(player.book_count).to eq 1
  end

  context 'json' do 
    it 'can convert itself into json' do 
      player = Player.new(name: 'Sydney', hand: [Card.new('Ace', 'Spades')], user_id: 1)
      result = player.as_json.with_indifferent_access
      expect(result).to eq({
        'name' => player.name,
        'hand' => 
          [{'rank'=> 'Ace', 'suit' => 'Spades' }],
        'books' => [],
        'user_id' => 1
      })
    end

    it 'can inflate json back into an object' do 
      player_json = {
        'name' => 'Sydney',
        'hand' => 
          [{'rank'=> 'Ace', 'suit' => 'Spades' }],
        'books' => ['Aces', '4s']
      }
      player = Player.from_json(player_json)
      expect(player.hand).to eq [Card.new('Ace', 'Spades')]
      expect(player.name).to eq 'Sydney'
      expect(player.books).to eq ['Aces', '4s']
    end

    fit 'can inflate an json player without a hand' do 
      player_hash = {
        'user_id' => 1
      }
      player = Player.from_json(player_hash)
      expect(player.hand).to eq []
    end
  end

end