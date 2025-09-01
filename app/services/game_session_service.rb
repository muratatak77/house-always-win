# frozen_string_literal: true

# Service class for handling game session creation and retrieval logic
class GameSessionService
  ServiceResult = Struct.new(:game_session, :status, keyword_init: true)

  def self.call(browser_session:, params:)
    new(browser_session: browser_session, params: params).call
  end

  def initialize(browser_session:, params:)
    @browser_session = browser_session
    @params = params
  end

  def call
    # First check if browser already has a valid open session
    if (existing_session = find_remembered_session)
      return ServiceResult.new(game_session: existing_session, status: :ok)
    end

    player = find_or_initialize_player

    # Check if player already has an open session
    if (open_session = find_player_open_session(player))
      store_session_identifiers(player, open_session)
      return ServiceResult.new(game_session: open_session, status: :ok)
    end

    # Create new session if none exists
    create_new_session(player)
  rescue ActiveRecord::RecordNotUnique
    # Handle race condition where session was created by another process
    handle_concurrent_creation(player)
  end

  private

  attr_reader :browser_session, :params

  # Returns remembered open session if valid and exists
  def find_remembered_session
    session_id = browser_session[:game_session_id]
    return unless session_id

    game_session = GameSession.find_by(id: session_id)
    game_session if game_session&.open?
  end

  def find_or_initialize_player
    return Player.find(browser_session[:player_id]) if browser_session[:player_id]
    return Player.find(params[:player_id]) if params[:player_id]

    Player.create!(account_credits: 0)
  end

  def find_player_open_session(player)
    player.game_sessions.open.first
  end

  def create_new_session(player)
    game_session = player.game_sessions.create!(status: :open)
    store_session_identifiers(player, game_session)
    ServiceResult.new(game_session: game_session, status: :created)
  end

  def handle_concurrent_creation(player)
    open_session = find_player_open_session(player)
    store_session_identifiers(player, open_session) if open_session
    ServiceResult.new(game_session: open_session, status: :ok)
  end

  def store_session_identifiers(player, game_session)
    browser_session[:player_id] = player.id
    browser_session[:game_session_id] = game_session.id
  end
end