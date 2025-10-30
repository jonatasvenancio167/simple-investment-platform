# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    scope = User.order(created_at: :desc)

    if params[:name].present?
      scope = scope.where("LOWER(name) LIKE ?", "%#{params[:name].to_s.downcase}%")
    end

    if params[:email].present?
      scope = scope.where("LOWER(email) LIKE ?", "%#{params[:email].to_s.downcase}%")
    end

    @per_page = (params[:per_page].presence || 5).to_i.clamp(1, 100)
    @page = (params[:page].presence || 1).to_i
    @page = 1 if @page < 1

    @total_count = scope.count
    @total_pages = [(@total_count.to_f / @per_page).ceil, 1].max
    @page = [@page, @total_pages].min

    @users = scope.offset((@page - 1) * @per_page).limit(@per_page)
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: "Usuário criado com sucesso."
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence.presence || "Não foi possível criar o usuário. Verifique os campos."
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Usuário atualizado com sucesso."
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence.presence || "Não foi possível atualizar o usuário. Verifique os campos."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_url, notice: "Usuário removido com sucesso."
    else
      redirect_to @user, alert: @user.errors.full_messages.to_sentence
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
