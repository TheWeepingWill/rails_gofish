require 'rails_helper'
require 'pry'

RSpec.describe 'Sign In', type: :system do 
  it 'signs in properly' do
    # given 
    name = 'Braden'
    visit root_path
    # when 
    fill_in 'Name', with: name
    fill_in 'Email',  with: 'braden@something.org'
    fill_in 'Password',  with: 'password', match: :first
    fill_in 'Password confirmation',  with: 'password'
    expect { click_on 'Create my account' }.to change { User.count }.from(0).to(1)

    #then
    expect(page).to have_content 'Log Out'
    expect(page).to have_content 'Create Game'
    expect(page).to have_content 'Join Game'
  end

  it 'shows validation messages when the email is taken' do 
    # given 
    existing_user = create(:user)
    visit root_path

    # when
    fill_in 'Name', with: existing_user.name
    fill_in 'Email',  with: existing_user.email
    fill_in 'Password',  with: 'password', match: :first
    fill_in 'Password confirmation',  with: 'password'
    expect { click_on 'Create my account' }.not_to change { User.count }

    # then
    expect(page).to have_content 'has already been taken'
  end
end