Feature: User creates a new player
  In order to play the game
  As a user
  I want to login and create a player character
  
  Scenario: User logs in and is taken to the player creation screen
    Given a user called "JoeBloggs"
    When I go to the homepage
    And I follow "Login"
    And I fill in "Username" with "JoeBloggs"
    And I fill in "Password" with "password123"
    And I press "Login"
    Then I should see "Create new player character"
    
  Scenario: User creates a new player
    Given I am logged in as a user called "JoeBloggs"
    When I fill in "Name" with "Joe the Awesome"
    And I choose "player_avatar_paladin"
    And I press "Create"
    Then I should be on the game index page
    And I should see "Player successfully created."
