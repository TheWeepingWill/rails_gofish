require 'rails_helper'
RSpec.describe Card do 
    
  it 'Creates a card' do 
    card = Card.new( '3', 'Hearts')
    expect(card.rank).to eq '3'
    expect(card.suit).to eq 'Hearts' 
  end

  it 'will not create an invalid card' do 
    card = Card.new('hello', 'world')
    expect(card.rank).to eq nil
    expect(card.suit).to eq nil
  end

  it 'has a value' do 
    card = Card.new( '3', 'Hearts')
    expect(card.value).to eq 2
  end

  it 'can compare to another card' do 
    card1 = Card.new( '3', 'Hearts')
    card2 = Card.new( '5', 'Hearts')
    expect(card1 == card2).to be false
  end

  it 'can transform into json' do 
    card1 = Card.new( '3', 'Hearts')
    results = card1.as_json.with_indifferent_access
    expect(results).to eq({ 'rank' => card1.rank, 'suit' => card1.suit })
  end

  it 'can inflate json back into an object' do 
    card_json = { 'rank' => '3', 'suit' => 'Hearts' }
    card = Card.from_json(card_json)
    expect(card).to eq Card.new('3', 'Hearts')
  end

end