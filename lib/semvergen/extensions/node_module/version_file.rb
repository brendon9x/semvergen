module Semvergen
  module Extensions
    module NodeModule
      class VersionFile

        def initialize(file)
          @file = file
        end

        def version=(new_version)
          content = file.read.gsub(/"version".*$/, %Q["version": "#{new_version}",])
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

      end
    end
  end
end
