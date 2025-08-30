class AddSymbolsToRolls < ActiveRecord::Migration[8.0]
  def change
    add_column :rolls, :symbols, :string, array: true, default: [], null: false
  end
end
