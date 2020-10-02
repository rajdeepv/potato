module TodoApp
  class AddTodoPage < BasePage
    TEXT_BOX_NOTE_TITLE = Android::Locator.builder.id('userToDoEditText').build
    ADD_BUTTON = Android::Locator.builder.id('makeToDoFloatingActionButton').build

    def add_todo_with_title(note_text)
      SystemUnderTest.device.automation_engine.enter_text(TEXT_BOX_NOTE_TITLE, note_text)
      SystemUnderTest.device.automation_engine.tap_element(ADD_BUTTON)
    end
  end
end