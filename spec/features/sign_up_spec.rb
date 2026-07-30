# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'SignUps', type: :feature do
  before :each do
  end
  describe 'validate phone' do
    it 'less than 10 digits' do
      validate_field(['Phone'], ['123'], true, 'Phone is invalid')
    end
    it 'more than 10 digits' do
      validate_field(['Phone'], ['123123456000'], true, 'Phone is invalid')
    end
    it 'exactly 10 digits' do
      validate_field(['Phone'], ['1231234560'], false, 'Phone is invalid')
    end
  end
  describe 'validate email' do
    it 'blank field' do
      validate_field(['Email'], [''], true, "Email can't be blank")
    end
    it 'without @' do
      validate_field(['Email'], ['abcgmail.com'], true, 'Email is invalid')
    end
    it 'without .com' do
      validate_field(['Email'], ['abc@gmail'], true, 'Email is invalid')
    end
    it 'correct email' do
      validate_field(['Email'], ['abc@gmail.com'], false, 'Email is invalid')
    end
  end
  describe 'validate password' do
    it 'blank field' do
      validate_field(['Password'], [''], true, "Password can't be blank")
    end
    it 'less than 6 digits' do
      validate_field(['Password'], ['123'], true, 'Password is too short (minimum is 6 characters)')
    end
    it 'valid password' do
      validate_field(['Password'], ['123456'], false, 'Password must be more than 6 digits')
    end
    it 'passord confirmation doesnt match' do
      validate_field(['Password', 'Password confirmation'], %w[123456 123], false, 'Password does not match')
    end
  end
  describe 'validate address' do
    it 'all blank' do
      validate_field(['Street'], [''], true, "street can't be blank")
      validate_field(['City'], [''], true, "city can't be blank")
      validate_field(['Zip'], [''], true, "zip can't be blank")
    end
    it 'street blank' do
      validate_field(['Street'], [''], true, "street can't be blank")
      validate_field(['City'], ['abc'], false, "city can't be blank")
      validate_field(['Zip'], ['123123'], false, "zip can't be blank")
    end
    it 'city blank' do
      validate_field(['Street'], ['abc'], false, "street can't be blank")
      validate_field(['City'], [''], true, "city can't be blank")
      validate_field(['Zip'], ['123123'], false, "zip can't be blank")
    end
    it 'zip blank' do
      validate_field(['Street'], ['abc'], false, "street can't be blank")
      validate_field(['City'], ['abc'], false, "city can't be blank")
      validate_field(['Zip'], [''], true, "zip can't be blank")
    end
    it 'zip invalid' do
      validate_field(['Street'], ['abc'], false, "street can't be blank")
      validate_field(['City'], ['abc'], false, "city can't be blank")
      validate_field(['Zip'], ['abc'], true, 'zip is not a number')
    end
  end
  describe 'on click login' do
    it 'click login' do
      visit 'users/sign_up'
      click_link 'Log in'
      expect(page).to have_current_path(new_user_session_path)
    end
  end
  def validate_field(fields, values, have_response, response)
    visit 'users/sign_up'
    fields.each_with_index do |field, index|
      fill_in field, with: values[index]
    end
    click_button 'Sign up'
    if have_response
      expect(page).to have_content response
    else
      expect(page).to have_no_content response
    end
  end
end
