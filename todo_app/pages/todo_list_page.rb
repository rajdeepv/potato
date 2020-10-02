module TodoApp
  class TodoListPage < BasePage
    NOTE_TITLE = Android::Locator.builder.id('toDoListItemTextview').build

    def get_first_todo
      SystemUnderTest.device.automation_engine.wait_for_element(NOTE_TITLE)
      SystemUnderTest.device.automation_engine.get_text(NOTE_TITLE)
    end
  end
end
