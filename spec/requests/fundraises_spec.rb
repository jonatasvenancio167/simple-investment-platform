require "rails_helper"

RSpec.describe "Fundraises", type: :request do
  describe "GET /fundraises" do
    it "lists fundraises with actions column and links" do
      fundraise = create(:fundraise)

      get fundraises_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Ações")
      expect(response.body).to include("Mostrar")
      expect(response.body).to include("Editar")
      expect(response.body).to include("Excluir")
      expect(response.body).to include(fundraise.title)
    end
  end
end