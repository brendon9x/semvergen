module Semvergen

  class ChangeLogFile

    def <<(message)
      current_change_log = File.exist?(change_log_file) ? File.read(change_log_file) : ""
      new_change_log     = "# Changelog\n\n#{message}" + current_change_log.gsub("# Changelog\n", "")
      File.open(change_log_file, "w") { |f| f.write new_change_log }
    end

    private

    def change_log_file
      File.join("CHANGELOG.md")
    end

  end

end