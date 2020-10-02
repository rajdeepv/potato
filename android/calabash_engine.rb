require 'calabash-android'
require_relative 'calabash_automation/calabash_driver'

module Potato
  class CalabashEngine
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

    def enter_text(element, text)
      @driver.enter_text(element, text)
    end

    def get_text(element)
      @driver.query(element, :text).first
    end

    def wait_for_element(element)
      sleep 1
    end
  end
end