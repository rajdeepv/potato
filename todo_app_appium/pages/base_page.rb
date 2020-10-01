module TodoApp
  class BasePage
    def ui
      SystemUnderTest.device.ui_automation
    end
  end
end