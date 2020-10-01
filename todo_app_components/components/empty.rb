module TodoApp
  module Empty
    if ::SystemUnderTest.automation_type_appium?
      ADD_ITEM = {id: 'addToDoItemFAB'}
    else
      ADD_ITEM = "* id:'addToDoItemFAB'"
    end

    def click_add
      ui.tap_element(ADD_ITEM)
    end
  end
end