# frozen_string_literal: true

class CashOut < ApplicationRecord
  belongs_to :player
  belongs_to :game_session

  validates :amount, numericality: {greater_than_or_equal_to: 0}
end
