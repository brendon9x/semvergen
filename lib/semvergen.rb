require "semvergen/version"

require "semvergen/launcher"
require "semvergen/interface"
require "semvergen/bump"
require "semvergen/release"
require "semvergen/change_log_file"
require "semvergen/shell"
require "semvergen/version_file"

require "semvergen/extensions/node_module/version_file"

require "yaml"

module Semvergen

  def self.bump!(options)
    launcher.bump!(options)
  end

  def self.release!(options)
    launcher.release!(options)
  end

  private

  def self.launcher
    Semvergen::Launcher.new
  end

end
