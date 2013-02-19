Feature: Signing user in/out
  Background:
    Given there is a user "testuser", his email is "testmail@example.com" and his pwd is "foobar12"

  Scenario:
    When I sign in as testuser, foobar12
    Then I should be signed in
    And There should be link to my page
    And There should be link to sign out

  Scenario:
    When I sign in as testuser, foobar12
    And I sign out
    Then I should not be signed in
    And There should be link to sign in
    And There should be link to sign up
