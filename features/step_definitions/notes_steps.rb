Given(/^I start creating a new note$/) do
  Potato::NotesListPage.new.tap_add_note
end