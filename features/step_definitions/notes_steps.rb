When(/^I add a reminder "([^"]*)"$/) do |note_text|
  todo_list_page = TodoApp::EmptyListPage.new
  todo_list_page.click_add

  add_todo_page = TodoApp::AddTodoPage.new
  add_todo_page.add_todo_with_title(note_text)
end

Then(/^I should see my reminder "([^"]*)" in reminders list$/) do |note_text|
  todo_app_todo_list_page = TodoApp::TodoListPage.new
  raise 'Note not found' unless todo_app_todo_list_page.get_first_todo(note_text)
end

When(/^I add an empty note$/) do
  add_todo_page = TodoApp::AddTodoPage.new
  add_todo_page.add_todo_with_title('')
end


Then(/^I should see an empty reminder error$/) do
  require 'pry'; binding.pry
end