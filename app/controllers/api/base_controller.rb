class Api::BaseController < ApplicationController
  # skip_forgery_protection

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from OrderService::OrderError, with: :unprocessable

  private

  def not_found
    render json: { error: "Record not found" }, status: :not_found
  end

  def unprocessable(exception)
    Rails.logger.error("OrderError: #{exception.message}")
    render json: { error: exception.message }, status: :unprocessable_entity
  end
end
