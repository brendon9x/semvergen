module Semvergen

  class Launcher

    def bump!(options={})
      Semvergen::Bump.new(interface, version_file, node_version_file, change_log_file, shell, gem_name, gem_server, notifier).run!(options)
    end

    def release!(options={})
      Semvergen::Release.new(interface, version_file, node_version_file, change_log_file, shell, gem_name, gem_server, notifier).run!(options)
    end

    private

    def version_file
      if File.exist? version_path
        VersionFile.new(File.open(version_path, "r+"))
      else
        interface.fail_exit "A bundler style version file should be found at #{version_path}"
      end
    end

    def node_version_file
      if config["node_module"]
        if File.exist? node_version_path
          Extensions::NodeModule::VersionFile.new(File.open(node_version_path, "r+"))
        else
          interface.fail_exit "A npm style version file should be found at #{node_version_path}"
        end
      end
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

    def node_version_path
      File.join("package.json")
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
      if File.exists?(gem_server_file)
        File.read(gem_server_file)
      elsif (gem_server = config["gemserver"])
        gem_server
      else
        interface.fail_exit "To publish, place the url (with optional username and pass) in a .gem_server file"
      end
    end

    def gem_server_file
      File.join(".gem_server")
    end

    def config
      @config ||= if File.exist?(config_path)
        YAML.load_file(config_path) || {}
      else
        {}
      end
    end

    def config_path
      File.join(".semvergen")
    end

    def notifier
      if config["slack"]
        require 'semvergen/slack_notifier'
        SlackNotifier.new config["slack"]
      else
        require 'semvergen/null_notifier'
        NullNotifier.new
      end
    end

  end

end
