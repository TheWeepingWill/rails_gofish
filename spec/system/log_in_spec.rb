require 'rails_helper'

RSpec.describe 'Log In', type: :system do 
  let!(:user) { create(:user) }
  it 'Logs in with valid info' do 
    # given
    visit login_path
    # when 
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log In'
    # then
    expect(page).to have_content user.name
  end

  let!(:user) { create(:user) }
  it 'Logs in with valid info' do 
    # given
    visit login_path
    # when 
    fill_in 'Email', with: "invalid_email@email.org"
    fill_in 'Password', with: user.password
    click_on 'Log In'
    # then
    expect(page).to have_content 'Incorrect User or Password'
  end
end