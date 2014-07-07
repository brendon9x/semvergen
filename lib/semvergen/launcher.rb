module Semvergen

  class Launcher

    def bump!(options={})
      Semvergen::Bump.new(interface, version_file, change_log_file, shell).run!(options)
    end

    def release!(options={})
      Semvergen::Release.new(gem_name, gem_server).run!(options)
    end

    private

    def version_file
      VersionFile.new(File.open(version_path, "r+"))
    end

    def change_log_file
      ChangeLogFile.new
    end

    def shell
      Shell.new
    end

    def version_path
      File.join("lib", gem_name, "version.rb")
    end

    def gem_name
      File.basename(gem_spec).gsub(".gemspec", "")
    end

    def interface
      @interface ||= Interface.new
    end

    def gem_spec
      gemspecs = Dir["*.gemspec"]
      interface.fail_exit("No gemspec found in current dir") if gemspecs.count == 0
      interface.fail_exit("More than one gemspec found in current dir") if gemspecs.count > 1

      gemspecs[0]
    end

    def gem_server
      File.read(gem_server_file)
    end

    def gem_server_file
      File.join(".gem_server")
    end

  end

end