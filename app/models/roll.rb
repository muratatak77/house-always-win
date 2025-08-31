# frozen_string_literal: true

class Roll < ApplicationRecord
  SYMBOLS = %w[C L O W].freeze

  # associations
  belongs_to :game_session

  # validations
  validates :symbols, presence: true
  validates :reward, numericality: {greater_than_or_equal_to: 0}
  validate :symbols_have_length_three
  validate :symbols_are_allowed

  private

  def symbols_have_length_three
    return if symbols.is_a?(Array) && symbols.size == 3

    errors.add(:symbols, 'must have 3 items')
  end

  def symbols_are_allowed
    return unless symbols.is_a?(Array)

    return unless symbols.any? { |s| SYMBOLS.exclude?(s) }

    errors.add(:symbols, 'has invalid item')
  end
end
