RSpec.describe 'Card' do 
    
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

end