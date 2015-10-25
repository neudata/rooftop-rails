module Rooftop
  module Rails
    class Engine < ::Rails::Engine

      isolate_namespace Rooftop::Rails

      config.before_initialize do
        if Rooftop::Rails.configuration.nil?
          Rooftop::Rails.configure {}
        end
      end

      initializer "configure_rooftop", before: :add_entry_mappings do
        Rooftop.configure do |config|
          config.api_token = Rooftop::Rails.configuration.api_token
          config.site_name = Rooftop::Rails.configuration.site_name
          config.extra_headers = Rooftop::Rails.configuration.extra_headers
          config.advanced_options = Rooftop::Rails.configuration.advanced_options
          config.api_path = Rooftop::Rails.configuration.api_path
          config.url = Rooftop::Rails.configuration.url || "http://#{config.site_name}.rooftopcms.io"
          config.perform_caching = Rooftop::Rails.configuration.perform_caching
          config.cache_store = Rooftop::Rails.configuration.cache_store
          config.cache_logger = Rooftop::Rails.configuration.cache_logger
        end
      end

      initializer "add_preview_support" do
        ActiveSupport.on_load(:action_controller) do
          include Rooftop::Rails::Preview
        end
      end
    end
  end
end
