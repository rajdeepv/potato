Feature: Notes
  Scenario: Add Note
    When I add a reminder "Pick Kids from School"
    Then I should see my reminder "Pick Kids from School" in reminders list