require 'rails_helper'

RSpec.describe User, type: :model do
  let (:user) { User.new(name: 'William', email: 'will@gmail.com', password: 'password') }

  it 'needs a name' do 
    user.name = ' '
    expect(user.valid?).to be false
  end

  it 'sets a name correctly' do 
    user.name = 'hellos' 
    expect(user.valid?).to be true
  end

  it 'errors if the name is longer than 50 chars' do 
    user.name = 'a' * 51
    expect(user.valid?).to be false
  end

  it 'needs an email' do
    user.email = ' '
    expect(user.valid?).to be false
  end

  it 'is valid if the email format is correct' do 
    user.email = 'something@example.org' 
    expect(user.valid?).to be true
  end

  it 'is invalid if the email format is incorrect' do 
    user.email = 'something@example' 
    expect(user.valid?).to be false
  end

  it 'is invalid if the email is longer than 255 chars' do
    user.name = 'a' * 255 + 'dam@gmail.org'
    expect(user.valid?).to be false 
  end

  it 'needs a password' do 
    user.password = ' '
    expect(user.valid?).to be false
  end

  it 'is valid if the password is longer than 6 chars' do 
    user.password= 'password' 
    expect(user.valid?).to be true
  end
end
