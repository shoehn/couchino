require 'jim'

module Couchino
  module Plugins
    class Jim < Couchino::Plugin

      name 'jim'

      def before_build
        jimfile = File.join(app_dir, 'Jimfile')
        ::Jim.logger = logger
        logger.debug "bundling js"
        bundler = ::Jim::Bundler.new(File.read(jimfile), ::Jim::Index.new(app_dir))
        # set the base dir relative to the app
        bundler.bundle_dir = app_dir + bundler.bundle_dir
        bundler.bundle!
      end

    end
  end
end
