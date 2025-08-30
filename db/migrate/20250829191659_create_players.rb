class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players do |t|
      t.string :email, null: false
      t.integer :account_credits, null: false, default: 0

      t.timestamps
    end

    add_index :players, :email, unique: true
  end
end
