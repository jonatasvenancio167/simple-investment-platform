class InvestmentsController < ApplicationController
  before_action :set_investment, only: %i[show edit update destroy]

  def index
    @investments = Investment.includes(:user, :fundraise).order(created_at: :desc)
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
end
