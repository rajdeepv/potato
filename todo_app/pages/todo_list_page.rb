module TodoApp
  class TodoListPage < BasePage

    if ::SystemUnderTest.automation_type_appium?
      NOTE_TITLE = {id: 'toDoListItemTextview'}
    else
      NOTE_TITLE = "* id:'toDoListItemTextview'"
    end

    def get_first_todo
      SystemUnderTest.device.automation_engine.wait_for_element(NOTE_TITLE)
      SystemUnderTest.device.automation_engine.get_text(NOTE_TITLE)
    end
  end
end
