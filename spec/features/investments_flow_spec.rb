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
    expect(page).to have_content("Detalhes do Investimento")
  end

  it "aplica filtros e paginação na listagem" do
    other_user = create(:user, name: "Outro Usuário")
    other_offer = create(:fundraise, status: "open", title: "Outra")
    create(:investment, user: other_user, fundraise: other_offer, amount_cents: 20_000)

    visit investments_path
    expect(page).to have_select("Usuário")
    expect(page).to have_select("Oferta")
    expect(page).to have_field("Valor mín (R$)")
    expect(page).to have_field("Valor máx (R$)")

    select other_user.name, from: "Usuário"
    select other_offer.title, from: "Oferta"
    click_button "Filtrar"

    expect(page).to have_content(other_user.name)
    expect(page).to have_content(other_offer.title)

    select "5", from: "Por página"
    click_button "Filtrar"
    expect(page).to have_content("Página")
  end

  it "possui breadcrumb e botão Voltar para Dashboard" do
    visit investments_path
    expect(page).to have_link("Dashboard", href: root_path)
    expect(page).to have_link("Voltar", href: root_path)
  end
end