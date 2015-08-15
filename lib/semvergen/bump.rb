module Semvergen

  class Bump

    extend Forwardable

    PATCH = "Patch: Bug fixes, recommended for all (default)"
    MINOR = "Minor: New features, but backwards compatible"
    MAJOR = "Major: Breaking changes"

    RELEASE_TYPES = [
      PATCH,
      MINOR,
      MAJOR
    ]

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

    def run!(options)
      unless @shell.current_branch == "master"
        say color("You are not on master. It is not recommended to create releases from a branch", :red)
        newline
        return unless agree("Proceed anyway? ")
        newline
      end

      unless @shell.git_branch_is_tracking?
        @interface.fail_exit color("This branch is not tracking a remote branch. Aborting...", :red)
      end

      say "Checking for upstream changes..."
      @shell.git_fetch
      newline

      unless @shell.git_up_to_date?
        @interface.fail_exit color("This branch is not up to date with upstream", :red)
      end

      say "Git status: #{color("Up to date", :green)}"
      newline

      if @shell.git_index_dirty? && !options[:ignore_dirty]
        say color("Git index dirty. Commit changes before continuing", :red, :bold)
      else
        say color("Cut new #{@gem_name} Release", :white, :underline, :bold)

        newline

        release_type = choose do |menu|
          menu.header    = "Select release type"
          menu.default   = "1"
          menu.select_by = :index
          menu.choices *RELEASE_TYPES
        end

        new_version = next_version(@version_file.version, release_type)

        newline

        say "Current version: #{color(@version_file.version, :bold)}"
        say "Bumped version : #{color(new_version, :bold, :green)}"

        newline

        say "Enter change log features (or a blank line to finish):"

        features = []

        while true
          response = ask "* " do |q|
            q.validate                 = lambda { |answer| features.size > 0 || answer.length > 0 }
            q.responses[:not_valid]    = color("Enter at least one feature", :red)
            q.responses[:invalid_type] = color("Enter at least one feature", :red)
            q.responses[:ask_on_error] = "* "
          end

          if response.length == 0
            features << "\n"
            break
          else
            features << "* #{response}"
          end
        end

        change_log_lines   = ["# #{new_version}"] + features
        change_log_message = change_log_lines.join("\n")
        diff_change_log    = change_log_lines.map { |l| color("+++ ", :white) + color(l, :green) }.join("\n")

        newline

        say color("Will add the following to CHANGELOG.md", :underline)
        say color(diff_change_log)

        commit_message = "Version bump: #{new_version}"

        newline

        say color("Summary of actions:", :underline, :green, :red)
        newline

        say "Bumping version: #{color(@version_file.version, :yellow)} -> #{color(new_version, :green)}"
        newline

        say "Adding features to CHANGELOG.md:"
        say color(diff_change_log, :green)

        say "Staging files for commit:"
        say color("* #{@version_file.path}", :green)
        say color("* CHANGELOG.md", :green)
        newline

        say "Committing with message: #{color(commit_message, :green)}"
        newline

        if agree("Proceed? ")
          @version_file.version = new_version

          @change_log_file << change_log_message

          @shell.commit(@version_file.path, new_version, commit_message, features)

          @shell.push(new_version)

          newline
        end

        Semvergen::Release.new(
          @interface,
          @version_file,
          @change_log_file,
          @shell,
          @gem_name,
          @gem_server,
          @notifier
        ).run!(features: features)

      end
    end

    def next_version(current_version, release_type)
      version_tuples = current_version.split(".")

      release_index = 2 - RELEASE_TYPES.index(release_type)

      bumping   = version_tuples[release_index]
      unchanged = version_tuples[0...release_index]
      zeroing   = version_tuples[(release_index + 1)..-1]

      new_version_tuples = unchanged + [bumping.to_i + 1] + (["0"] * zeroing.size)

      new_version_tuples.join(".")
    end

  end

end
