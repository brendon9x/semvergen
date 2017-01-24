module Semvergen

  class ChangeLogFile

    def initialize(change_log_filename=nil)
      @change_log_filename = change_log_filename || "CHANGELOG.md"
    end

    def <<(message)
      current_change_log = File.exist?(@change_log_filename) ? File.read(@change_log_filename, :encoding => "UTF-8") : ""
      new_change_log     = "# Changelog\n\n#{message}" + current_change_log.gsub("# Changelog\n", "")
      File.open(@change_log_filename, "w") { |f| f.write new_change_log }
    end

    def features(version=nil)
      features_for_version(version || latest_version)
    end

    private

    def latest_version
      lines = File.readlines(@change_log_filename).map { |l| l.chomp }
      Array(lines.slice_before(/^#/))[1][0].gsub("# ", "")
    end

    def features_for_version(version)
      lines = File.readlines(@change_log_filename).map { |l| l.chomp }
      features = lines.slice_before(/^#/).select { |a| a.first == "# #{version}" }.first[1..-1]
      features.select do |feature|
        !feature.empty?
      end.compact
    end

  end

end
