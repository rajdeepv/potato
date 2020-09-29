module Potato
  class NotesListPage < Potato::BasePage

    ADD_BUTTON = {id: 'addToDoItemFAB'}

    def tap_add_note
      ui.driver.find_element(ADD_BUTTON).click
    end
  end
end