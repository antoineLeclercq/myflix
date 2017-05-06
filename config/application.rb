require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module Myflix
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.autoload_paths << Rails.root.join('lib')
    config.active_support.escape_html_entities_in_json = true

    config.assets.enabled = true
    config.generators do |g|
      g.orm :active_record
      g.template_engine :haml
    end
  end
end

Raven.configure do |config|
  config.dsn = 'https://9cc9b443b2ab41e6a4c907d140fb4ec5:9b71b3d815484dcab130dc6a1cd923d5@sentry.io/165696'
end
