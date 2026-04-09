class Api::UsersController < Api::BaseController
  def index
    Rails.logger.debug("Showing list od users")
    users = User.includes(:account).order(created_at: :desc)
    render json: users
  end

  def show
    Rails.logger.debug("Showing user ##{user.id}")
    render json: user
  end

  def create
    Rails.logger.debug("Creating new user")
    user = User.create!(user_params)
    render json: user, status: :created
  end

  private

  def user
    @user ||= User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
