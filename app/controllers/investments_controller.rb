class InvestmentsController < ApplicationController
  before_action :set_investment, only: %i[show edit update destroy]

  def index
    scope = Investment.includes(:user, :fundraise).order(created_at: :desc)

    @users = User.order(:name)
    @fundraises = Fundraise.order(:title)

    if params[:user_id].present?
      scope = scope.where(user_id: params[:user_id])
    end

    if params[:fundraise_id].present?
      scope = scope.where(fundraise_id: params[:fundraise_id])
    end

    min_cents = parse_amount_to_cents(params[:min_amount])
    max_cents = parse_amount_to_cents(params[:max_amount])
    scope = scope.where("amount_cents >= ?", min_cents) if min_cents
    scope = scope.where("amount_cents <= ?", max_cents) if max_cents

    @per_page = (params[:per_page].presence || 5).to_i.clamp(1, 100)
    @page = (params[:page].presence || 1).to_i
    @page = 1 if @page < 1

    @total_count = scope.count
    @total_pages = [(@total_count.to_f / @per_page).ceil, 1].max
    @page = [@page, @total_pages].min

    @investments = scope.offset((@page - 1) * @per_page).limit(@per_page)
  end

  def show; end

  def new
    @investment = Investment.new
  end

  def create
    @investment = Investment.new(investment_params)
    if @investment.save
      redirect_to investment_path(@investment), notice: "Investimento criado com sucesso."
    else
      flash.now[:alert] = @investment.errors.full_messages.to_sentence.presence || "Não foi possível criar o investimento. Verifique os campos."
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @investment.update(investment_params)
      redirect_to @investment, notice: "Investimento atualizado com sucesso."
    else
      flash.now[:alert] = @investment.errors.full_messages.to_sentence.presence || "Não foi possível atualizar o investimento. Verifique os campos."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @investment.destroy
      redirect_to investments_url, notice: "Investimento removido com sucesso."
    else
      redirect_to @investment, alert: @investment.errors.full_messages.to_sentence
    end
  end

  private

  def set_investment
    @investment = Investment.find(params[:id])
  end

  def investment_params
    params.require(:investment).permit(:user_id, :fundraise_id, :amount_cents)
  end

  def parse_amount_to_cents(value)
    return nil if value.blank?
    bd = BigDecimal(value.to_s)
    (bd * 100).to_i
  rescue ArgumentError
    nil
  end
end
