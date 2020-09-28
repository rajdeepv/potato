Before do
  uninstall_apps
  @driver = Appium::Driver.new(default_caps, false)
  @driver.start_driver
end

After do
  @driver.quit_driver
end