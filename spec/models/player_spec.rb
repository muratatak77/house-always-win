# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Player, type: :model do
  describe 'validations' do
    it 'is valid with email' do
      expect(build(:player)).to be_valid
    end

    it 'requires unique email' do
      create(:player, email: 'a@b.com')
      expect(build(:player, email: 'a@b.com')).not_to be_valid
    end

    it 'has non-negative account_credits' do
      p = build(:player, account_credits: -1)
      expect(p).not_to be_valid
    end
  end

  describe 'associations' do
    it 'has many game_sessions' do
      assoc = described_class.reflect_on_association(:game_sessions)
      expect(assoc.macro).to eq(:has_many)
    end

    it 'has many cash_outs' do
      assoc = described_class.reflect_on_association(:cash_outs)
      expect(assoc.macro).to eq(:has_many)
    end
  end

  describe 'dependent behavior' do
    it 'destroys game_sessions when player is destroyed' do
      player = create(:player)

      # Create one open and one closed session
      create(:game_session, player: player, status: :open)
      create(:game_session, player: player, status: :closed)

      expect { player.destroy }.to change(GameSession, :count).by(-2)
    end

    it 'nullifies cash_outs.player_id when player is destroyed' do
      # We tie cash_out to another player's session to avoid FK conflict.
      # This is test-only setup. In real flow, both belong to same player.
      owner      = create(:player)
      other_user = create(:player)
      other_sess = create(:game_session, player: other_user, status: 0)

      co = create(:cash_out, player: owner, game_session: other_sess, amount: 7)

      expect { owner.destroy }.to change { described_class.where(id: owner.id).count }.from(1).to(0)

      co.reload
      expect(co.player_id).to be_nil
      expect(co.game_session_id).to eq(other_sess.id)
    end
  end
end
