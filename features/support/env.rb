require_relative 'system_under_test'
require_relative '../../android/device'
require_relative '../../todo_app_components/components'
require_relative '../../todo_app/pages'

if SystemUnderTest.automation_engine == 'appium'
  require_relative '../../android/appium_engine'
elsif SystemUnderTest.automation_engine == 'calabash'
  require_relative '../../android/calabash_engine'
else
  raise("Invalid automation type")
end
