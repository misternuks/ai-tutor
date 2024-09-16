class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!

  def index
    @users = User.order(created_at: :desc).page(params[:page]).per(100)
  end

  def toggle_instructor
    @user = User.find(params[:id])
    @user.instructor = !@user.instructor
    if @user.save
      redirect_to admin_users_path, notice: "User updated successfully."
    else
      redirect_to admin_users_path, alert: "Failed to update user."
    end
  end

  private

  def ensure_admin!
    redirect_to(root_path, alert: "You are not authorized to perform this action.") unless current_user.admin?
  end
end
