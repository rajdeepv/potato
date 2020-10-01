module TodoApp
  class EmptyListPage < BasePage
    def click_add
      ui.driver.find_element(id:'addToDoItemFAB').click
    end
  end
end