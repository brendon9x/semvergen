module Semvergen

  class Release

    def initialize(gem_name, gem_server)
      @gem_name = gem_name
      @gem_server = gem_server
    end

    def run!(options)
      say "Found gemspec: #{color(@gem_name, :green)}"
      newline

      say color("Building gem: ")
      `gem build #{@gemspec_file} --force`
      say color("OK", :green, :bold)

      fail_exit("Need .gem_server file in current dir (with full URL) to release gem") unless File.exist? gem_server_file

      say color("Publishing: ")
      @shell.publish(@gem_name, @version_file.version, @gem_server)
      say color("OK", :green, :bold)
    end

  end
end
