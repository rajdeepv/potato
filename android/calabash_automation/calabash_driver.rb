module Potato
  class CalabashDriver
    include Calabash::Android::Operations

    def start_driver
      reinstall_apps
      start_test_server_in_background
    end

    def quit_driver
      shutdown_test_server
    end
  end
end