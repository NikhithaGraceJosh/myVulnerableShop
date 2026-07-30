# frozen_string_literal: true

require 'rails_helper'
require 'faker'

RSpec.feature 'SignIns', type: :feature do
  # pending "add some scenarios (or delete) #{__FILE__}"

  before :each do
    @user = create(:user, email: Faker::Internet.email, admin: false)
    @admin = create(:user, email: Faker::Internet.email, admin: true)
  end

  it 'signs me in' do
    test_sign_in(@user.email, @user.password, "Hey, #{@user.name.split(' ')[0]}")
  end

  it 'wrong password' do
    test_sign_in(@user.email, '13456', 'Invalid')
  end

  it 'wrong email' do
    test_sign_in('user@com', @user.password, 'Invalid')
  end

  it 'wrong email and password' do
    test_sign_in('example.com', '12344', 'Invalid')
  end

  describe 'admin login' do
    it 'admin success' do
      test_sign_in(@admin.email.to_s, @admin.password.to_s, 'Add product')
    end
    it 'admin fail' do
      visit '/users/sign_in'
      within('.login-form') do
        fill_in 'user_email', with: @admin.email
        fill_in 'user_password', with: @admin.password
      end
      click_button 'Log in'
      expect(page).to have_no_content 'Cart'
    end
  end
  describe 'user login' do
    it 'test 1' do
      test_sign_in(@user.email.to_s, @user.password.to_s, 'Cart')
    end
    it 'test 2' do
      visit '/users/sign_in'
      within('.login-form') do
        fill_in 'user_email', with: @user.email
        fill_in 'user_password', with: @user.password
      end
      click_button 'Log in'
      expect(page).to have_no_content 'Add Product'
    end
  end
  def test_sign_in(email, password, response)
    visit '/users/sign_in'
    within('.login-form') do
      fill_in 'user_email', with: email
      fill_in 'user_password', with: password
    end
    click_button 'Log in'
    expect(page).to have_content response
  end
end
