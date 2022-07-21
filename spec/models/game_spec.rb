require 'rails_helper'

RSpec.describe Game, type: :model do 

  let!(:valid_game) { create(:game, users: [create(:user)])}
  let!(:invalid_game) { Game.new }
  
  it 'initializes' do 
    expect(!!Game.new).to be true
  end

  it 'needs a name and player count' do 
    expect(invalid_game).not_to be_valid
    expect(valid_game).to be_valid
  end

  it 'has remaining players' do 
    expect(valid_game.remaining_players).to be 1
  end 
  
  it 'can be started' do 
    started_game = create(:game, :started)
    expect(started_game).to be_started_at 
    expect(started_game.started_at).to be_within(1.minute).of(Time.now)
  end

  context '#start!' do 
    it 'starts the game' do 
      game = create(:game, users: [create(:user), create(:user)])
      game.start!
      expect(game).to be_started_at
    end

    it 'will not start with the incorrect amount of players' do 
      game = create(:game)
      game.start!
      expect(game).not_to be_started_at
    end
  end
  
  context '#current_player' do 
    fit 'has a current player' do 
      game = create(:game, users: [create(:user, name: 'Josh'), create(:user)])

      game.start!
      expect(game.current_player.name).to eq game.users[0].name
    end
  end

  context '#go_fish' do 
    it 'saves a gofish game to Json' do 
      user1 = create(:user)
      user2 = create(:user)
      player1 = Player.new(name: "Player #{user1.id}")
      player2 = Player.new(name: "Player #{user2.id}")
      go_fish = GoFish.new(players: [player1, player2])
      go_fish.start
      game = create(:game, users: [ user1, user2 ])
      game.go_fish = go_fish


      expect(game.go_fish).not_to be_nil
    end 

    it 'inflates json back into an gofish object' do 
      user1 = create(:user)
      user2 = create(:user)
      
      go_fish_json = {
        'players' => [{
          'hand' => [{'rank' => 'Ace', 'suit' => 'Spades'}]
        }, 
        {
          'hand' => [{'rank' => '2', 'suit' => 'Diamonds'}]
        }],
        'deck' => {
          'cards' => [{'rank' => '4', 'suit' => 'Diamonds'}, 
                      {'rank' => '7', 'suit' => 'Clubs'}]
        }
      }

      game = create(:game, go_fish: GoFish.load(go_fish_json))
      expect(game.go_fish.players[0].hand[0]).to eq Card.new('Ace', 'Spades')
      expect(game.go_fish.deck.cards[0]).to eq Card.new('4', 'Diamonds')
    end

    
  end
end