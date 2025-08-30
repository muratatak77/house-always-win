class CreateCashOuts < ActiveRecord::Migration[8.0]
  def change
    create_table :cash_outs do |t|
      t.integer :amount, null: false

      t.timestamps
    end
  end
end
