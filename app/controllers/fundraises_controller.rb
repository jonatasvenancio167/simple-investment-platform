# app/controllers/fundraises_controller.rb
class FundraisesController < ApplicationController
  before_action :set_fundraise, only: %i[show edit update destroy]

  def index
    scope = Fundraise.order(created_at: :desc)

    if params[:title].present?
      scope = scope.where("LOWER(title) LIKE ?", "%#{params[:title].to_s.downcase}%")
    end

    if params[:status].present?
      scope = scope.where(status: params[:status])
    end

    @per_page = (params[:per_page].presence || 5).to_i.clamp(1, 100)
    @page = (params[:page].presence || 1).to_i
    @page = 1 if @page < 1

    @total_count = scope.count
    @total_pages = [(@total_count.to_f / @per_page).ceil, 1].max
    @page = [@page, @total_pages].min

    @fundraises = scope.offset((@page - 1) * @per_page).limit(@per_page)
  end

  def show; end

  def new
    @fundraise = Fundraise.new
  end

  def edit; end

  def create
    @fundraise = Fundraise.new(fundraise_params)
    if @fundraise.save
      redirect_to @fundraise, notice: "Oferta criada com sucesso."
    else
      flash.now[:alert] = @fundraise.errors.full_messages.to_sentence.presence || "Não foi possível criar a oferta. Verifique os campos."
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @fundraise.update(fundraise_params)
      redirect_to @fundraise, notice: "Oferta atualizada com sucesso."
    else
      flash.now[:alert] = @fundraise.errors.full_messages.to_sentence.presence || "Não foi possível atualizar a oferta. Verifique os campos."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @fundraise.destroy
      redirect_to fundraises_url, notice: "Oferta removida com sucesso."
    else
      redirect_to @fundraise, alert: @fundraise.errors.full_messages.to_sentence
    end
  end

  private

  def set_fundraise
    @fundraise = Fundraise.find(params[:id])
  end

  def fundraise_params
    params.require(:fundraise).permit(:title, :description, :status, :starts_at, :ends_at, :target, :target_cents)
  end
end
