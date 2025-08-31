# frozen_string_literal: true

class ChangeDefaultCreditsForGameSessions < ActiveRecord::Migration[8.0]
  def change
    change_column_default :game_sessions, :credits, from: 10, to: nil
  end
end
