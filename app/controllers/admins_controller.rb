class AdminsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin

  def dashboard
    @unverified_users = User.unverified
    @unverified_users = @unverified_users.with_email(params[:search_email]) if params[:search_email].present?
  end

  def verify_user
    user = User.find(params[:id])
    if user.update(verified: true)
      redirect_to dashboard_path, notice: "User #{user.email} has been verified."
    else
      redirect_to dashboard_path, alert: "User verification failed."
    end
  end

  private

  def ensure_admin
    redirect_to root_path, alert: "Access denied." unless current_user&.admin?
  end
end
