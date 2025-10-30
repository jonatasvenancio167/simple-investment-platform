require "rails_helper"

RSpec.describe "Fundraises flow", type: :system do
  before { driven_by(:rack_test) }

  it "aplica filtros por Título e Status, e paginação" do
    create(:fundraise, title: "Série A", status: "open")
    create(:fundraise, title: "Bridge", status: "closed")

    visit fundraises_path
    expect(page).to have_content("Ofertas")
    expect(page).to have_field("Título")
    expect(page).to have_select("Status")

    select "Aberta", from: "Status"
    click_button "Filtrar"
    expect(page).to have_content("Série A")
    expect(page).not_to have_content("Bridge")

    fill_in "Título", with: "bridge"
    select "Fechada", from: "Status"
    click_button "Filtrar"
    expect(page).to have_content("Bridge")
    expect(page).not_to have_content("Série A")

    select "5", from: "Por página"
    click_button "Filtrar"
    expect(page).to have_content("Página")
  end

  it "possui breadcrumb e botão Voltar para Dashboard" do
    visit fundraises_path
    expect(page).to have_link("Dashboard", href: root_path)
    expect(page).to have_link("Voltar", href: root_path)
  end
end