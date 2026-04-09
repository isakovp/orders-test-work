require "test_helper"

class OrderTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(name: "Test User", email: "test@example.com")
    @order = @user.orders.create!(name: "Test Order", amount: 100)
  end

  test "should create order with valid data" do
    order = @user.orders.new(name: "New Order", amount: 50)
    assert order.save
  end


  test "should not create order with zero or negative amount" do
    order1 = @user.orders.new(name: "Bad Order", amount: 0)
    order2 = @user.orders.new(name: "Bad Order 2", amount: -10)
    assert_not order1.save
    assert_not order2.save
  end

  test "should have created status by default" do
    assert_equal "created", @order.status
  end

  test "should complete order successfully" do
    @user.reload
    initial_balance = @user.account.balance
    completed_order = OrderService.complete(@order)
    @user.reload

    assert_equal "completed", completed_order.status
    assert_equal initial_balance + @order.amount, @user.account.balance
    assert_equal 1, @user.account.transactions.count
    assert_equal "credit", @user.account.transactions.last.kind
  end


end
