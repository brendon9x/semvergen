module Semvergen

  class NullNotifier

    def gem_published(gem_name, new_version, change_log_message)
      # no-op
    end

  end

end