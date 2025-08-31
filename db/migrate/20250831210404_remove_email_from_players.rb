# frozen_string_literal: true

class RemoveEmailFromPlayers < ActiveRecord::Migration[8.0]
  def change
    remove_column :players, :email, :string
  end
end
