class Api::OrdersController < Api::BaseController
  def index
    orders = Order.includes(:user).order(created_at: :desc)
    render json: orders
  end

  def show
    render json: order
  end

  def create
    Rails.logger.debug("Creating new order")
    order = user.orders.create!(order_params)
    render json: order, status: :created
  end

  def complete
    Rails.logger.debug("Completing order ##{order.id}")
    updated_order = OrderService.complete(order)
    render json: updated_order
  end

  def cancel
    Rails.logger.debug("Cancelling order ##{order.id}")
    updated_order = OrderService.cancel(order)
    render json: updated_order
  end

  private

  def order
    @order ||= Order.find(params[:id])
  end

  def user
    @user ||= User.find(params[:user_id]) if params[:user_id]
    @user ||= order.user
  end

  def order_params
    params.require(:order).permit(:name, :amount)
  end
end
