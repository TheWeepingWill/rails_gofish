require 'rails_helper'

RSpec.describe Game, type: :model do 

  let!(:valid_game) { Game.new(name: 'Game', player_count: 2) }
  let!(:invalid_game) { Game.new }
  
  it 'initializes' do 
    expect(!!Game.new).to be true
  end

  it 'needs a name and player count' do 
    expect(invalid_game).not_to be_valid
    expect(valid_game).to be_valid
  end
  
end