# frozen_string_literal: true

class Player < ApplicationRecord
  # if we delete player, delete all their sessions
  has_many :game_sessions, dependent: :destroy

  # if we delete player, nullify their cash_outs
  has_many :cash_outs, dependent: :nullify

  validates :email, presence: true, uniqueness: true
  validates :account_credits, numericality: {greater_than_or_equal_to: 0}
end
