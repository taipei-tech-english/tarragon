require 'rails_helper'

RSpec.feature "Converters", type: :feature do
  context "parse common era" do
    scenario "user enters valid inputs" do
      visit root_path
      visit convert_path

      fill_in 'q', with: '1932 05 6'
      click_button 'Convert'
      expect(page).to have_content('date in common era')
      expect(page).to have_selector("input[value='1932 05 6']")

      fill_in 'q', with: '1920.3.26 1923/7/5'
      click_button 'Convert'
      expect(page).to have_content('date range in common era')
      expect(page).to have_selector("input[value='1920.3.26 1923/7/5']")

      fill_in 'q', with: 'faLl 1971'
      click_button 'Convert'
      expect(page).to have_content('semester in common era')
      expect(page).to have_selector("input[value='faLl 1971']")

      fill_in 'q', with: 'spring 1984–fAll 1986'
      click_button 'Convert'
      expect(page).to have_content('semester range in common era')
      expect(page).to have_selector("input[value='spring 1984–fAll 1986']")
    end

    scenario "user enters invalid inputs" do
      visit root_path
      visit convert_path
      fill_in 'q', with: '1998 9 31'
      click_button 'Convert'

      expect(page).to have_content('You’ve entered an invalid date. Please check your input and try again.')
      expect(page).to have_selector("input[value='1998 9 31']")
    end
  end
end
