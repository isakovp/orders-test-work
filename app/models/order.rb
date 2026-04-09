class Order < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy

  enum :status, {
    created: "created",
    completed: "completed",
    cancelled: "cancelled"
  }

  validates :name, presence: true
  validates :amount, numericality: { greater_than: 0 }

end
