module Semvergen

  class Release

    extend Forwardable

    def_delegators :@interface, :say, :ask, :color, :choose, :newline, :agree

    def initialize(interface, version_file, change_log_file, shell, gem_name, gem_server, notifier)
      @interface = interface
      @version_file = version_file
      @change_log_file = change_log_file
      @shell = shell
      @gem_name = gem_name
      @gem_server = gem_server
      @notifier = notifier
    end

    def run!(options={})
      if agree("Release? ")
        say "Found gemspec: #{color(@gem_name, :green)}"
        newline

        say color("Building gem: ")
        @shell.build_gem(@gem_name)
        say color("OK", :green, :bold)

        say color("Publishing: ")
        @shell.publish(@gem_name, @version_file.version, @gem_server)
        say color("OK", :green, :bold)

        features = options[:features] || gem_features
        @notifier.gem_published(@gem_name, gem_version, features.join("\n"))

        @shell.cleanup(@gem_name, gem_version) rescue say color("Unable to cleanup", :red)
      end
    end

    private

    def gem_version
      @version_file.version
    end

    def gem_features
      @change_log_file.features
    end


  end

end