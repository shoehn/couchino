require 'sass/plugin'
require 'compass'
require 'compass/logger'

module Couchino
  module Plugins
    class Compass < Couchino::Plugin

      name 'compass'

      def before_build
        Couchino.logger.info "compiling compass"

        unless Couchino.debug
          options = {:logger => ::Compass::NullLogger.new}.merge(self.options)
        end

        compass = ::Compass::Compiler.new(app_dir, compass_from, compass_to, ::Compass.sass_engine_options.merge(options || {}))
        Couchino.logger.debug "compass: #{compass.inspect}"
        compass.run
      end

      private
      def compass_from
        options.has_key?(:from) ? File.join(app_dir, options[:from]) : File.join(app_dir, 'sass')
      end

      def compass_to
        options.has_key?(:to) ? File.join(app_dir, options[:to]) : File.join(app_dir, 'css')
      end
    end
  end
end
