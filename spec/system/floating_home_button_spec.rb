require "rails_helper"

RSpec.describe "Floating home button", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:user) { create(:user) }
  let!(:fundraise) { create(:fundraise) }
  let!(:investment) { create(:investment, user: user, fundraise: fundraise) }

  it "appears on Investments page and navigates back to Home" do
    visit investments_path
    expect(page).to have_css(".floating-home-btn[aria-label='Voltar para a página principal']")

    find(".floating-home-btn").click
    expect(page).to have_current_path(root_path)
  end

  it "appears on Fundraises page and navigates back to Home" do
    visit fundraises_path
    expect(page).to have_css(".floating-home-btn[aria-label='Voltar para a página principal']")

    find(".floating-home-btn").click
    expect(page).to have_current_path(root_path)
  end

  it "appears on Users page and navigates back to Home" do
    visit users_path
    expect(page).to have_css(".floating-home-btn[aria-label='Voltar para a página principal']")

    find(".floating-home-btn").click
    expect(page).to have_current_path(root_path)
  end
end