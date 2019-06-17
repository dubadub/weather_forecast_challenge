require "rails_helper"

feature "Search for the city", js: true do
  before { build_limerick.save }

  scenario "It finds Limerick" do
    visit root_path

    expect(page).to have_content "What's the forecast up there"

    fill_in "Search a city by name...", with: "Limerick"

    click_on "Limerick, US"

    expect(page).to have_content "16 days weather forecast for Limerick, US"
  end
end

