require 'calabash-android'
require_relative 'calabash_automation/calabash_driver'

module Potato
  class CalabashAutomation
    def driver
      @driver
    end

    def start
      @driver = CalabashDriver.new
      @driver.start_driver
    end

    def stop
      @driver.quit_driver
    end

    #################################
    def tap_element(element)
      @driver.touch(element)
    end
  end
end