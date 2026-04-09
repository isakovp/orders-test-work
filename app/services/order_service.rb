class OrderService
  class OrderError < StandardError; end

  def self.complete(order)
    new(order).complete
  end

  def self.cancel(order)
    new(order).cancel
  end

  def initialize(order)
    @order = order
  end

  def complete
    validate_status!(:created)
    transaction do
      @order.completed!
      create_transaction(:credit, "Payment for order ##{@order.id}")
      update_balance(@order.amount)
    end
    reload_order
  end

  def cancel
    validate_status!(:completed)
    transaction do
      @order.cancelled!
      create_transaction(:debit, "Refund for order ##{@order.id}")
      update_balance(-@order.amount)
    end
    reload_order
  end

  private

  attr_reader :order

  def validate_status!(expected_status)
    current_status = @order.status.to_sym
    return if current_status == expected_status

    status_word = expected_status == :created ? "complete" : "cancel"
    raise OrderError, "Cannot #{status_word} order: expected '#{expected_status}', got '#{current_status}'"
  end

  def transaction(&block)
    ActiveRecord::Base.transaction(&block)
  end

  def create_transaction(kind, description)
    order.user.account.transactions.create!(
      amount: order.amount,
      kind: kind,
      order: order,
      description: description
    )
  end

  def update_balance(amount_change)
    order.user.account.update!(
      balance: order.user.account.balance + amount_change
    )
  end

  def reload_order
    order.reload
  end
end
