RSpec.describe 'Player' do 

  describe '#initialize' do 
    it 'creates an object without paramaters' do 
      player = Player.new
      expect(player.name).to eq ''
      expect(player.hand).to eq []
    end

    it 'creates an object with paramaters' do 
      player = Player.new(name: 'Sydney')
      expect(player.name).to eq 'Sydney'
      expect(player.hand).to eq []
    end
  end

  it 'can retrieve a list of ranks' do 
    player = Player.new(name: 'Sydney', hand: [Card.new('Ace', 'Spades'), Card.new('Ace', 'Hearts'), Card.new('Jack', 'Spades'), Card.new('3', 'Spades')])
    expect(player.hand_ranks).to eq (['Ace', 'Jack', '3'])
  end

  it 'counts books' do 
    player = Player.new(name: 'Sydney', hand: [Card.new('Ace', 'Spades'), Card.new('Ace', 'Hearts'), Card.new('Ace', 'Clubs'), Card.new('3', 'Spades')])
    player.take_cards(Card.new('Ace', 'Diamonds'))
    expect(player.hand_count).to eq 1
    expect(player.book_count).to eq 1
  end

end