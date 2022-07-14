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
    it 'has a current player' do 
      game = create(:game, users: [create(:user, name: 'Josh'), create(:user)])

      game.start!
      expect(game.current_player.name).to eq game.users[0].name
    end
  end
end