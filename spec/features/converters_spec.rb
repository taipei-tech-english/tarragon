require 'rails_helper'

RSpec.feature "Converters", type: :feature do
  context "parse common era" do
    scenario "user enters a valid common era date" do
      visit root_path
      visit convert_path
      fill_in 'q', with: '1932 05 6'
      click_button 'Convert'

      expect(page).to have_content('date in common era')
      expect(page).to have_selector("input[value='1932 05 6']")
    end

    scenario "user enters an invalid common era date" do
      visit root_path
      visit convert_path
      fill_in 'q', with: '1998 9 31'
      click_button 'Convert'

      expect(page).to have_content('You’ve entered an invalid date. Please check your input and try again.')
      expect(page).to have_selector("input[value='1998 9 31']")
    end
  end
end
