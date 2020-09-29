require 'appium_lib'
require 'appium_lib/driver'

ESPRESSO_PKG = 'io.appium.espressoserver.test'
APP_PATH = 'apks/appium_notes.apk'
APP_PACKAGE = 'com.avjindersinghsekhon.minimaltodo'
ESPRESSO_SERVER_PATH = 'apks/espresso_server_notes.apk'


def connected_devices
  lines = `adb devices`.split("\n")
  start_index = lines.index { |x| x =~ /List of devices attached/ } + 1
  lines[start_index..-1].collect { |l| l.split("\t").first }
end


def install_apps
  `#{adb_command} uninstall #{ESPRESSO_PKG}` if app_installed?(ESPRESSO_PKG)
  `#{adb_command} uninstall #{APP_PACKAGE}` if app_installed?(APP_PACKAGE)
  `#{adb_command} install #{APP_PATH}`
  `#{adb_command} install #{ESPRESSO_SERVER_PATH}`
end

def app_installed?(package_name)
  matching_packages = `#{adb_command} shell pm list packages | grep #{package_name}`.split
  res = matching_packages.include?("package:#{package_name}")
  puts "app_installed = #{res}"
  res
end

def adb_command
  "adb -s #{adb_device_arg}"
end

def adb_device_arg
  ENV.fetch('ADB_DEVICE_ARG',connected_devices.first)
end

def reserve_port
  `#{adb_command} forward tcp:0 tcp:6790`.strip
end

def default_caps
  opts = {
      caps:
          {
              app:                    APP_PATH,
              platformName:           'Android',
              deviceName:             adb_device_arg,
              udid:                   adb_device_arg,
              appPackage:             APP_PACKAGE,
              appWaitActivity:        '*',
              automationName:         'espresso',
              skipServerInstallation: true,
              newCommandTimeout:      0,
              system_port:            reserve_port,
              autoGrantPermissions:   true, # If noReset is true, this capability doesn't work.
              skipUnlock:             true,
              fullReset:              false,
              tmpDir:                 "#{Dir.tmpdir}/appium_temp/#{ENV.fetch('WORKER_INDEX', '0')}",
          },
      appium_lib:
          {
              debug:      false,
              server_url: "http://localhost:#{ENV.fetch('APPIUM_PORT',4723)}/wd/hub",
          },
  }

  # puts("USING SERVER = #{opts[:appium_lib][:server_url]}")
  # puts("USING DEVICE = #{opts[:caps][:deviceName]}")
  # puts("USING PORT = #{opts[:caps][:system_port]}")
  opts
end