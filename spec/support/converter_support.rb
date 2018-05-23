module ConverterSupport
  def fill_and_convert(input, expected)
    fill_in 'q', with: input
    click_button 'Convert'
    expect(page).to have_content(expected)
    expect(page).to have_selector("input[value='#{input}']")
  end
end
