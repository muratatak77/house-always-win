# frozen_string_literal: true

class GameSession < ApplicationRecord
  # associations
  belongs_to :player
  has_many :rolls, dependent: :destroy

  # enums
  enum :status, {open: 0, closed: 1}, default: :open

  attribute :credits, :integer, default: 10

  # validations
  before_validation :ensure_default_credits
  validates :credits, numericality: {greater_than_or_equal_to: 0}

  private

  def ensure_default_credits
    self.credits = 10 if credits.nil?
  end
end
