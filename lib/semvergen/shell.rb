module Semvergen

  class Shell

    def initialize(execute_function = method(:system_exec).to_proc)
      @execute_function = execute_function
    end

    def git_index_dirty?
      execute("git status --porcelain") =~ /^\s*(D|M|A|R|C)\s/
    end

    def commit(version_path, new_version, commit_subject, features)
      commit_body = COMMIT_MESSAGE % [new_version, commit_subject, features.join("\n")]

      execute "git add CHANGELOG.md"
      execute "git add #{version_path}"
      execute %Q[git commit -m "#{commit_body}"]
    end

    def build_gem(gem_name)
      execute "gem build #{gem_name}.gemspec --force"
    end

    def publish(gem_name, version, gem_server)
      execute "gem inabox #{gem_name}-#{version}.gem --host #{gem_server}"
    end

    private

    def execute(command)
      @execute_function[command]
    end

    def system_exec(command)
      result = `#{command}`
      raise if $?.exitstatus > 0
      result
    end

    COMMIT_MESSAGE = <<-STR
Version %s: %s

%s
    STR

  end

end