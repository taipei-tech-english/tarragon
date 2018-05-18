require 'rails_helper'

RSpec.feature "Converters", type: :feature do
  context "parse common era" do
    scenario "user enters a valid common era date" do
      visit root_path
      visit convert_path
      fill_in 'q', with: '1932 05 6'
      click_button 'Convert'

      expect(page).to have_content('date in common era')
    end
  end
end
