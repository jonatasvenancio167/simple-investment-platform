require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    it "lista usuários com coluna de ações e links" do
      user = create(:user)

      get users_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Ações")
      expect(response.body).to include("Mostrar")
      expect(response.body).to include("Editar")
      expect(response.body).to include("Excluir")
      expect(response.body).to include(user.name)
    end
  end

  describe "POST /users" do
    it "cria um novo usuário com dados válidos" do
      attrs = attributes_for(:user)

      expect {
        post users_path, params: { user: attrs }
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(user_path(User.last))
      follow_redirect!
      expect(response).to have_http_status(:ok)
    end

    it "retorna erro com dados inválidos" do
      attrs = attributes_for(:user, email: nil)

      expect {
        post users_path, params: { user: attrs }
      }.not_to change(User, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /users/:id" do
    it "atualiza um usuário existente" do
      user = create(:user)

      patch user_path(user), params: { user: { name: "Novo Nome" } }
      expect(response).to have_http_status(:found)
      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(user.reload.name).to eq("Novo Nome")
    end
  end

  describe "DELETE /users/:id" do
    it "remove um usuário sem investimentos" do
      user = create(:user)

      expect {
        delete user_path(user)
      }.to change(User, :count).by(-1)
      expect(response).to have_http_status(:found)
    end

    it "remove usuário com investimentos e destrói investimentos em cascata" do
      user = create(:user)
      offer = create(:fundraise, status: "open")
      create(:investment, user: user, fundraise: offer, amount_cents: 10_000)

      expect {
        delete user_path(user)
      }.to change(User, :count).by(-1).and change(Investment, :count).by(-1)
      expect(response).to have_http_status(:found)
    end
  end

  describe "GET /users com filtros e paginação" do
    it "filtra por nome (case-insensitive)" do
      ana = create(:user, name: "Ana", email: "ana@example.org")
      bruno = create(:user, name: "Bruno", email: "bruno@example.org")

      get users_path, params: { name: "an" }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(ana.name)
      expect(response.body).not_to include(bruno.name)
    end

    it "filtra por email (case-insensitive)" do
      ana = create(:user, name: "Ana", email: "ana@example.org")
      bruno = create(:user, name: "Bruno", email: "bruno@example.org")

      get users_path, params: { email: "BRUNO@EXAMPLE" }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(bruno.email)
      expect(response.body).not_to include(ana.email)
    end

    it "pagina resultados e preserva parâmetros" do
      names = %w[U1 U2 U3 U4 U5 U6]
      names.each { |n| create(:user, name: n) }

      get users_path, params: { per_page: 5, page: 2 }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Página 2")
      expect(response.body).to include("U1")
      expect(response.body).not_to include("U6")
    end
  end
end