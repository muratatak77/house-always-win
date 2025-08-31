# frozen_string_literal: true

class AddForeignKeysAndIndex < ActiveRecord::Migration[8.0]
  def up
    # Step 1: Add foreign key columns, indexes, and foreign key constraints
    # GameSession -> Player
    add_column :game_sessions, :player_id, :bigint
    add_index  :game_sessions, :player_id
    add_foreign_key :game_sessions, :players, column: :player_id

    # Roll -> GameSession
    add_column :rolls, :game_session_id, :bigint
    add_index  :rolls, :game_session_id
    add_foreign_key :rolls, :game_sessions, column: :game_session_id

    # cash_out -> Player, GameSession
    add_column :cash_outs, :player_id, :bigint
    add_column :cash_outs, :game_session_id, :bigint
    add_index  :cash_outs, :player_id
    add_index  :cash_outs, :game_session_id, unique: true # 1 session -> 1 cash out
    add_foreign_key :cash_outs, :players,       column: :player_id
    add_foreign_key :cash_outs, :game_sessions, column: :game_session_id

    # Step 2: Add partial unique index to ensure one active session per player
    add_index :game_sessions, :player_id,
              unique: true,
              where: 'status = 0',
              name: 'idx_unique_open_session_per_player'
  end

  def down
    remove_index :game_sessions, name: 'idx_unique_open_session_per_player'

    remove_foreign_key :cash_outs,    column: :game_session_id
    remove_foreign_key :cash_outs,    column: :player_id
    remove_foreign_key :rolls,        column: :game_session_id
    remove_foreign_key :game_sessions, column: :player_id

    remove_index :cash_outs,  :game_session_id
    remove_index :cash_outs,  :player_id
    remove_index :rolls,      :game_session_id
    remove_index :game_sessions, :player_id

    remove_column :cash_outs,   :game_session_id
    remove_column :cash_outs,   :player_id
    remove_column :rolls,       :game_session_id
    remove_column :game_sessions, :player_id
  end
end
