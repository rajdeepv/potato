module TodoApp
  class BasePage
    def ui
      SystemUnderTest.device.automation_engine
    end
  end
end