require_relative '../../android/device'

class Context
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

  Context.device = Potato::Device.new(Context.adb_device_arg, Potato::AppiumAutomation)
  Context.device.uninstall_apps([ESPRESSO_PKG, APP_PACKAGE])
  Context.device.start_aut
end

After do
  Context.device.stop_aut
end