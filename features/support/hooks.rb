Before do
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