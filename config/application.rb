require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module ImportApp
    class Application < Rails::Application
        config.active_record.schema_format = :ruby
        config.generators do |g|
            g.test_framework :rspec, fixtures: true, views: false, view_specs: false, helper_specs: false,
                routing_specs: false, controller_specs: true, request_specs: false
            g.fixture_replacement :factory_girl, dir: 'spec/factories'
        end
        config.active_record.raise_in_transactional_callbacks = true
        config.autoload_paths += %W(#{config.root}/lib/modules)
        config.autoload_paths += %W(#{config.root}/app/jobs)
        config.active_job.queue_adapter = :sidekiq
    end
end
