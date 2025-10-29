class DashboardsController < ApplicationController
  def index
    @total_users = User.count
    @total_fundraises = Fundraise.count
    @total_investments = Investment.count

    @recent_users = User.order(created_at: :desc).limit(5)
    @recent_fundraises = Fundraise.order(created_at: :desc).limit(5)
    @recent_investments = Investment.order(created_at: :desc).limit(5)
  end
end
