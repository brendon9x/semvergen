module Semvergen

  class Release

    extend Forwardable

    def_delegators :@interface, :say, :ask, :color, :choose, :newline, :agree

    def initialize(interface, gem_name, gem_server, shell, version_file)
      @interface = interface
      @gem_name = gem_name
      @gem_server = gem_server
      @shell = shell
      @version_file = version_file
    end

    def run!(options)
      say "Found gemspec: #{color(@gem_name, :green)}"
      newline

      say color("Building gem: ")
      @shell.build_gem(@gem_name)
      say color("OK", :green, :bold)

      say color("Publishing: ")
      @shell.publish(@gem_name, @version_file.version, @gem_server)
      say color("OK", :green, :bold)
    end

  end
end
