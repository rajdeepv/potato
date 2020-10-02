module TodoApp
  class AddTodoPage < BasePage
    if ::SystemUnderTest.automation_type_appium?
      TEXT_BOX_NOTE_TITLE = {id: 'userToDoEditText'}
      ADD_BUTTON = {id: 'makeToDoFloatingActionButton'}
    else
      TEXT_BOX_NOTE_TITLE = "* id:'userToDoEditText'"
      ADD_BUTTON = "* id:'makeToDoFloatingActionButton'"
    end

    def add_todo_with_title(note_text)
      SystemUnderTest.device.automation_engine.enter_text(TEXT_BOX_NOTE_TITLE, note_text)
      SystemUnderTest.device.automation_engine.tap_element(ADD_BUTTON)
    end
  end
end