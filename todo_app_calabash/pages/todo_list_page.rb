module TodoApp
  class TodoListPage < BasePage
    def get_first_todo(note_text)
      ui.driver.find_element(id: 'toDoListItemTextview').text == note_text
    end
  end
end
