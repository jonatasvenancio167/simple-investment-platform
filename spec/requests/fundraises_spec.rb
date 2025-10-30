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

    it "filtra por título (case-insensitive)" do
      fr1 = create(:fundraise, title: "Série A", status: "open")
      fr2 = create(:fundraise, title: "Bridge", status: "open")

      get fundraises_path, params: { title: "séri" }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(fr1.title)
    end

    it "filtra por status" do
      open_fr = create(:fundraise, status: "open")
      closed_fr = create(:fundraise, status: "closed")

      get fundraises_path, params: { status: "open" }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(open_fr.title)
    end

    it "pagina resultados e preserva parâmetros" do
      titles = %w[T1 T2 T3 T4 T5 T6]
      titles.each { |t| create(:fundraise, title: t, status: "open") }

      get fundraises_path, params: { per_page: 5, page: 2 }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Página 2")
      expect(response.body).to include("T1")
      expect(response.body).not_to include("T6")
    end
  end
end