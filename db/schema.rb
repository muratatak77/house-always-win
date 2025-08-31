# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_31_210404) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "cash_outs", force: :cascade do |t|
    t.integer "amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "player_id"
    t.bigint "game_session_id"
    t.index ["game_session_id"], name: "index_cash_outs_on_game_session_id", unique: true
    t.index ["player_id"], name: "index_cash_outs_on_player_id"
  end

  create_table "game_sessions", force: :cascade do |t|
    t.integer "credits", null: false
    t.integer "status", null: false
    t.datetime "last_roll_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "player_id"
    t.index ["player_id"], name: "idx_unique_open_session_per_player", unique: true, where: "(status = 0)"
    t.index ["player_id"], name: "index_game_sessions_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.integer "account_credits", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rolls", force: :cascade do |t|
    t.boolean "win", default: false, null: false
    t.integer "reward", default: 0, null: false
    t.boolean "cheated", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "game_session_id"
    t.string "symbols", default: [], null: false, array: true
    t.index ["game_session_id"], name: "index_rolls_on_game_session_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  add_foreign_key "cash_outs", "game_sessions"
  add_foreign_key "cash_outs", "players"
  add_foreign_key "game_sessions", "players"
  add_foreign_key "rolls", "game_sessions"
end
