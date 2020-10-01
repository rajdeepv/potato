module TodoApp
  class AddTodoPage < BasePage
    def add_todo_with_title(note_text)
      ui.driver.find_element(id:'userToDoEditText').send_keys("#{note_text}")
      ui.driver.find_element(id:'makeToDoFloatingActionButton').click
    end
  end
end