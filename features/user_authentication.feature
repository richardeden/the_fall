Feature: User authentication
  In order to build a community
  As a site owner
  I want people to create a user from which they can create multiple characters, login and logout
  
  Scenario: New user creation
    Given I am on the homepage
    When I follow "Register"
    And I fill in "Username" with "JoeBloggs"
    And I fill in "Email" with "joebloggs@example.com"
    And I fill in "Password" with "password123"
    And I fill in "Password Confirmation" with "password123"
    And I press "Submit"
    Then I should see "Registration successful."
  
  Scenario: User puts the wrong password into the password confirmation
    Given I am on the homepage
    When I follow "Register"
    And I fill in "Username" with "JoeBloggs"
    And I fill in "Email" with "joebloggs@example.com"
    And I fill in "Password" with "password123"
    And I fill in "Password Confirmation" with "password456"
    And I press "Submit"
    Then I should see "Password doesn't match confirmation"
  
  Scenario: User has a password that is less then 4 characters
    Given I am on the homepage
    When I follow "Register"
    And I fill in "Username" with "JoeBloggs"
    And I fill in "Email" with "joebloggs@example.com"
    And I fill in "Password" with "abc"
    And I fill in "Password Confirmation" with "abc"
    And I press "Submit"
    Then I should see "Password confirmation is too short (minimum is 4 characters)"
  
  Scenario: User logs in
    Given a user called "JoeBloggs"
    When I go to the homepage
    And I follow "Login"
    And I fill in "Username" with "JoeBloggs"
    And I fill in "Password" with "password123"
    And I press "Login"
    Then I should see "Successfully logged in."

