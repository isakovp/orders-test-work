class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :order

  enum :kind, { credit: "credit", debit: "debit" }

  validates :kind, presence: true
end
