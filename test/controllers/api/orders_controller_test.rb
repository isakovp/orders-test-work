require "test_helper"

class Api::OrdersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(name: "Test User", email: "test@example.com")
    @order = @user.orders.create!(name: "Test Order", amount: 100)
  end

  test "should get index" do
    get api_user_orders_url(@user)
    assert_response :success
  end

  test "should show order" do
    get api_user_order_url(@user, @order)
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal @order.id, json["id"]
  end

  test "should create order" do
    assert_difference("Order.count") do
      post api_user_orders_url(@user),
           params: { order: { name: "New Order", amount: 200 } },
           as: :json
    end
    assert_response :created
  end

  test "should complete order" do
    post complete_api_order_url(@order)
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "completed", json["status"]
  end

  test "should cancel completed order" do
    OrderService.complete(@order)

    post cancel_api_order_url(@order)
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "cancelled", json["status"]
  end

  test "should not complete invalid order" do
    @order.completed!
    post complete_api_order_url(@order)
    assert_response :unprocessable_entity
  end

  test "should not cancel non-completed order" do
    post cancel_api_order_url(@order)
    assert_response :unprocessable_entity
  end
end
