require "rails_helper"

RSpec.describe "Investments flow", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:user) { create(:user) }
  let!(:fundraise) { create(:fundraise, status: "open") }
  let!(:investment) { create(:investment, user: user, fundraise: fundraise, amount_cents: 10_000) }

  it "lists investments and navigates to show via 'Mostrar' link" do
    visit investments_path
    expect(page).to have_content("Ações")
    expect(page).to have_link("Mostrar")
    find(:link, "Mostrar", href: investment_path(investment)).click
    expect(page).to have_current_path(investment_path(investment))
    expect(page).to have_content("Detalhes do investimento")
  end
end