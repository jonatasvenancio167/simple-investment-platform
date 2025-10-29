require "rails_helper"

RSpec.describe "Investments", type: :request do
  describe "GET /investments" do
    it "lists investments with actions header and links" do
      user = create(:user)
      offer = create(:fundraise, status: "open")
      create(:investment, user: user, fundraise: offer, amount_cents: 15_000)

      get investments_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Ações")
      expect(response.body).to include("Mostrar")
      expect(response.body).to include("Editar")
      expect(response.body).to include("Excluir")
    end
  end

  describe "POST /investments" do
    it "creates a new investment with valid data" do
      user = create(:user)
      offer = create(:fundraise, status: "open")

      expect {
        post investments_path, params: { investment: { user_id: user.id, fundraise_id: offer.id, amount_cents: 15_000 } }
      }.to change(Investment, :count).by(1)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(investment_path(Investment.last))
      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Detalhes do investimento")
    end

    it "returns error with invalid data" do
      user = create(:user)
      offer = create(:fundraise, status: "closed")

      expect {
        post investments_path, params: { investment: { user_id: user.id, fundraise_id: offer.id, amount_cents: 0 } }
      }.not_to change(Investment, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /investments/:id" do
    it "updates an existing investment" do
      user = create(:user)
      offer = create(:fundraise, status: "open")
      inv = create(:investment, user: user, fundraise: offer, amount_cents: 10_000)

      patch investment_path(inv), params: { investment: { amount_cents: 20_000 } }
      expect(response).to have_http_status(:found)
      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(inv.reload.amount_cents).to eq(20_000)
    end
  end

  describe "DELETE /investments/:id" do
    it "destroys an investment" do
      user = create(:user)
      offer = create(:fundraise, status: "open")
      inv = create(:investment, user: user, fundraise: offer, amount_cents: 10_000)

      expect {
        delete investment_path(inv)
      }.to change(Investment, :count).by(-1)
      expect(response).to have_http_status(:found)
    end
  end
end