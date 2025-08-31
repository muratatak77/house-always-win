# frozen_string_literal: true

Rails.application.config.generators do |g|
  g.test_framework :rspec

  # do not create extra spec types if you want clean repo
  g.helper_specs false
  g.view_specs   false
  g.routing_specs false
  g.controller_specs false
  g.system_tests nil # no system tests (minitest)

  # optional: do not create helper/assets when generate
  g.helper false
  g.assets false
end
