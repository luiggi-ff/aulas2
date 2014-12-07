class UsersController < ApplicationController
  before_action :authenticate_user!
  before_filter :ensure_admin
        
  def ensure_admin
     redirect_to resources_path unless current_user.admin?
  end

  def index
     @users = User.all
  end

  private
    def user_params
        params.require(:user).permit(:full_name, :email, :admin)
    end

end
