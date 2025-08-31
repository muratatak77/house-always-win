# frozen_string_literal: true

module Api
  class BaseApiController < ActionController::API
    # common error handlers
    rescue_from ActionController::ParameterMissing, with: :render_bad_request
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

    private

    def render_bad_request(_err)
      render_error('bad_request', :bad_request)
    end

    def render_not_found(_err)
      code = respond_to?(:not_found_code, true) ? not_found_code : 'not_found'
      render_error(code, :not_found)
    end

    def render_error(code, status, extra = {})
      render json: {error: code}.merge(extra), status: status
    end
  end
end
