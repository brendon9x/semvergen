module Semvergen

  class Release

    extend Forwardable

    def_delegators :@interface, :say, :ask, :color, :choose, :newline, :agree

    def initialize(interface, version_file, node_version_file, change_log_file, shell, gem_name, gem_server, notifier)
      @interface = interface
      @version_file = version_file
      @node_version_file = node_version_file
      @change_log_file = change_log_file
      @shell = shell
      @gem_name = gem_name
      @gem_server = gem_server
      @notifier = notifier
    end

    def run!(options={})
      if agree("Release? ")
        if @gem_server == "rubygems.org" && !File.exist?(File.expand_path("~/.gem/credentials"))
          @interface.fail_exit("Could not find rubygems.org credentials file at ~/.gem/credentials. Please make sure this file exists and that it has the correct credentials before continuing.")
        end
        say "Found gemspec: #{color(@gem_name, :green)}"
        newline

        say color("Building gem: ")
        @shell.build_gem(@gem_name)
        say color("OK", :green, :bold)

        say color("Publishing: ")
        @shell.publish(@gem_name, @version_file.version, @gem_server)
        say color("OK", :green, :bold)

        if @node_version_file
          say color("Publishing to NPM: ")
          if @shell.publish_node_module.nil?
            say color("Error: npm CLI not found! Please ensure that 'npm publish' runs successfully", :underline, :red)
          end
        end

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
