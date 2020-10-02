Before do
  ui_automation_engine = if SystemUnderTest.automation_engine == 'appium'
                           Potato::AppiumEngine.new
                         elsif SystemUnderTest.automation_engine == 'calabash'
                           Potato::CalabashEngine.new
                         else
                           raise("Invalid automation type")
                         end
  SystemUnderTest.device = Potato::Device.new(SystemUnderTest.adb_device_arg, ui_automation_engine)
  SystemUnderTest.device.start_aut
end

After do
  SystemUnderTest.device.stop_aut
end