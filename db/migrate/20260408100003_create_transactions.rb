class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :account, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.decimal :amount, precision: 12, scale: 2, null: false
      t.string :kind, null: false  # credit, debit, reversal
      t.string :description

      t.timestamps
    end
    add_index :transactions, :kind
  end
end
