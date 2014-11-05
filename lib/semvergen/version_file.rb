module Semvergen

  class VersionFile

    def initialize(file)
      @file = file
    end

    def version
      if file.read =~ /VERSION\s*=\s*["'](\d+\.\d+\.\d+)["']/
        $1
      else
        raise "Don't understand version"
      end
    end

    def version=(new_version)
      content = file.read.gsub(/VERSION.*$/, %Q[VERSION = "#{new_version}"])
      file.truncate(0)
      file.write content
      file.flush
    end

    def file
      @file.rewind
      @file
    end

    def path
      @file.path
    end

    VERSION_TEMPLATE = <<-RUBY
module Quattro
  VERSION = "%s"
end
    RUBY

  end

end