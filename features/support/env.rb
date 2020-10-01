require_relative 'system_under_test'
require_relative '../../android/device'
require_relative '../../todo_app_components/components'

if SystemUnderTest.automation_type == 'appium'
  require_relative '../../android/appium_automation'
  require_relative '../../todo_app_appium/pages'
elsif SystemUnderTest.automation_type == 'calabash'
  require_relative '../../android/calabash_automation'
  require_relative '../../todo_app_calabash/pages'
else
  raise("Invalid automation type")
end
