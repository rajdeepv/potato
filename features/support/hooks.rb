require_relative '../../android/device'

class SystemUnderTest
  class << self
    attr_accessor :device

    def connected_devices
      lines = `adb devices`.split("\n")
      start_index = lines.index { |x| x =~ /List of devices attached/ } + 1
      lines[start_index..-1].collect { |l| l.split("\t").first }
    end


    def adb_device_arg
      ENV.fetch('ADB_DEVICE_ARG',connected_devices.first)
    end
  end
end


Before do
  ESPRESSO_PKG = 'io.appium.espressoserver.test'
  APP_PATH = 'apks/appium_notes.apk'
  APP_PACKAGE = 'com.avjindersinghsekhon.minimaltodo'
  ESPRESSO_SERVER_PATH = 'apks/espresso_server_notes.apk'

  driver = Potato::AppiumAutomation.new
  SystemUnderTest.device = Potato::Device.new(SystemUnderTest.adb_device_arg, driver)
  SystemUnderTest.device.start_aut
end

After do
  SystemUnderTest.device.stop_aut
end