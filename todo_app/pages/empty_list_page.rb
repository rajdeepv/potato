module TodoApp
  class EmptyListPage < BasePage
    ADD_ITEM = Android::Locator.builder.id('addToDoItemFAB').build

    def click_add
      SystemUnderTest.device.automation_engine.tap_element(ADD_ITEM)
    end
  end
end