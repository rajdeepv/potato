require 'appium_lib'
require 'appium_lib/driver'
require_relative 'appium_automation/keystore'

module Potato
  class AppiumAutomation

    def driver
      @driver
    end

    def default_caps
      keystore = Keystore.new('calabash_settings')
      opts = {
          caps:
              {
                  app: APP_PATH,
                  platformName: 'Android',
                  deviceName: SystemUnderTest.device.adb_device_arg,
                  udid: SystemUnderTest.device.adb_device_arg,
                  appPackage: APP_PACKAGE,
                  appWaitActivity: '*',
                  automationName: 'espresso',
                  newCommandTimeout: 0,
                  system_port: SystemUnderTest.device.reserve_port,
                  autoGrantPermissions: true, # If noReset is true, this capability doesn't work.
                  skipUnlock: true,
                  fullReset: false,
                  tmpDir: "#{Dir.tmpdir}/appium_temp/#{ENV.fetch('WORKER_INDEX', '0')}",
                  useKeystore: true,
                  keystorePath: keystore.keystore_location,
                  keystorePassword: keystore.keystore_password,
                  keyAlias: keystore.keystore_alias,
                  keyPassword: keystore.keystore_password,
                  showGradleLog: true
              },
          appium_lib:
              {
                  debug: false,
                  server_url: "http://localhost:#{ENV.fetch('APPIUM_PORT', 4723)}/wd/hub",
              },
      }

      # puts("USING SERVER = #{opts[:appium_lib][:server_url]}")
      # puts("USING DEVICE = #{opts[:caps][:deviceName]}")
      # puts("USING PORT = #{opts[:caps][:system_port]}")
      opts
    end

    def start
      @driver = Appium::Driver.new(default_caps, false)
      @driver.start_driver
    end

    def stop
      @driver.quit_driver
    end
  end
end