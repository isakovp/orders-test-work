class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.decimal :amount, precision: 12, scale: 2, null: false
      t.string :status, null: false, default: "created"

      t.timestamps
    end
    add_index :orders, :status
  end
end
