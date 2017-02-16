require_relative 'boot'

require "rails"
require "action_controller/railtie"
require "action_view/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module DnsTest
  class Application < Rails::Application
    config.autoload_paths << Rails.root.join('services')
  end
end
