# frozen_string_literal: true

class CreateGameSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :game_sessions do |t|
      t.integer :credits, null: false, default: 10
      t.integer :status, null: false
      t.datetime :last_roll_at

      t.timestamps
    end
  end
end
