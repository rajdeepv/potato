Feature: Notes
  Scenario: Add Note with text
    When I add a reminder "Pick Kids from School"
    Then I should see my reminder "Pick Kids from School" in reminders list

  Scenario: Add Note with number
    When I add a reminder "12345"
    Then I should see my reminder "12345" in reminders list