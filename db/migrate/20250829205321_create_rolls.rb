class CreateRolls < ActiveRecord::Migration[8.0]
  def change
    create_table :rolls do |t|
      t.boolean :win,  null: false, default: false
      t.integer :reward, null: false, default: 0
      t.boolean :cheated, null: false, default: false

      t.timestamps
    end
  end
end
