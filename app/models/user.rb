class User < ApplicationRecord
  has_one :account, dependent: :destroy
  has_many :orders, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  after_create :create_account

  private

  def create_account
    create_account!(balance: 0)
  end
end
