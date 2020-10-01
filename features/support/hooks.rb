Before do
  ESPRESSO_PKG = 'io.appium.espressoserver.test'
  APP_PATH = 'apks/appium_notes.apk'
  APP_PACKAGE = 'com.avjindersinghsekhon.minimaltodo'
  ESPRESSO_SERVER_PATH = 'apks/espresso_server_notes.apk'

  ui_automation =  if SystemUnderTest.automation_type == 'appium'
                     Potato::AppiumAutomation.new
                   elsif SystemUnderTest.automation_type == 'calabash'
                     Potato::CalabashAutomation.new
                   else
                     raise("Invalid automation type")
                   end
  SystemUnderTest.device = Potato::Device.new(SystemUnderTest.adb_device_arg, ui_automation)
  SystemUnderTest.device.start_aut
end

After do
  SystemUnderTest.device.stop_aut
end