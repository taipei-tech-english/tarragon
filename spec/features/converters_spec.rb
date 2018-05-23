require 'rails_helper'
include ConverterSupport

RSpec.feature "Converters", type: :feature do
  before do
    visit root_path
    visit convert_path
  end

  context "parse common era dates & semesters" do
    scenario "user enters valid inputs" do
      fill_and_convert('1932 05 6', 'date in common era')
      fill_and_convert('1920.3.26 1923/7/5', 'date range in common era')
      fill_and_convert('faLl 1971', 'semester in common era')
      fill_and_convert('spring 1984–fAll 1986', 'semester range in common era')
    end

    scenario "user enters invalid inputs" do
      fill_and_convert('1998 9 31', 'You’ve entered an invalid date. Please check your input and try again.')
      fill_and_convert('2015 5 30 2014 1 31', 'You’ve entered an invalid date range. Please check your input and try again.')
      fill_and_convert('Whatever 1911', 'Input is unrecognizable. Please check your input and try again.')
      fill_and_convert('Fall 1987 Spring 1987', 'You’ve entered an invalid semester range. Please check your input and try again.')
    end
  end

  # context "parse Minguo dates & semesters" do
  #   scenario "user enters valid inputs" do
  #     visit root_path
  #     visit convert_path
  #   end

  #   scenario "user enters invalid inputs" do
  #   end
  # end
end
