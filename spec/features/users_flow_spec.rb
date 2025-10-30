require "rails_helper"

RSpec.describe "Users flow", type: :system do
  before { driven_by(:rack_test) }

  it "aplica filtros por Nome e navega pela paginação" do
    create(:user, name: "Ana", email: "ana@example.org")
    create(:user, name: "Bruno", email: "bruno@example.org")

    visit users_path
    expect(page).to have_content("Usuários")
    expect(page).to have_field("Nome")
    expect(page).to have_field("Email")

    fill_in "Nome", with: "an"
    click_button "Filtrar"

    expect(page).to have_content("Ana")
    expect(page).not_to have_content("Bruno")

    select "10", from: "Por página"
    click_button "Filtrar"
    expect(page).to have_content("Página")
  end

  it "possui breadcrumb e botão Voltar para Dashboard" do
    visit users_path
    expect(page).to have_link("Dashboard", href: root_path)
    expect(page).to have_link("Voltar", href: root_path)
  end
end