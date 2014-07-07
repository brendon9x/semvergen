require 'highline/import'


module Semvergen

  class Interface < HighLine

    def fail_exit(message)
      say color(message, :red)
      exit 1
    end

  end

end
