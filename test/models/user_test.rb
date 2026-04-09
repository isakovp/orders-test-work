require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should create user with account" do
    user = User.create!(name: "New User", email: "new@example.com")
    assert user.account
    assert_equal 0, user.account.balance
  end

  test "should not create user without name" do
    user = User.new(email: "noname@example.com")
    assert_not user.save
  end

  test "should not create user without email" do
    user = User.new(name: "No Email")
    assert_not user.save
  end

  test "should not create user with duplicate email" do
    User.create!(name: "User 1", email: "dup@example.com")
    user2 = User.new(name: "User 2", email: "dup@example.com")
    assert_not user2.save
  end

  test "should destroy orders when user is destroyed" do
    user = User.create!(name: "Test User", email: "test@example.com")
    user.orders.create!(name: "Order 1", amount: 100)
    user.orders.create!(name: "Order 2", amount: 200)

    assert_difference("Order.count", -2) do
      user.destroy
    end
  end
end
