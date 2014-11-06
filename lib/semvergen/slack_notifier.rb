require 'slack-notifier'

module Semvergen

  class SlackNotifier

    def initialize(opts)
      @webhook_url = opts["webhook_url"]
      @username    = opts["username"]
      @icons       = opts["icons"]
    end

    def gem_published(gem_name, new_version, change_log_message)
      options = {}
      options[:icon_url] = @icons.sample if @icons
      options[:attachments] = [attachment(gem_name, new_version, change_log_message)]
      notifier.ping "Semvergen: release #{gem_name}", options
    end

    def notifier
      @notifier ||= Slack::Notifier.new(
        @webhook_url,
        username: @username
      )
    end

    def user
      [
        ENV["USER"],
        `whoami`
      ].compact.detect { |u| !u.nil? }
    end

    def attachment(gem_name, new_version, change_log_message)
      {
        title:     "#{user} has published a new version of '#{gem_name}'",
        fallback:  change_log_message,
        fields:    [
                     {title: "Version", value: new_version},
                     {title: "Change Log", value: change_log_message}

                   ],
        color:     "good",
        mrkdwn_in: ["text", "title", "fallback", "fields"]
      }
    end

  end

end