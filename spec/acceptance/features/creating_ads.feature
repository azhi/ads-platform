Feature: Creating advertisement for signed in user
  Background:
    Given there is a user "testuser", his email is "testmail@example.com" and his pwd is "foobar12"
    And I sign in as testuser, foobar12
    And there is a type "SomeType"

  Scenario:
    When I create advertisement "somecontent" with type "SomeType" and pic url "http://example.com/pic1.jpg"
    Then an advertisement count should increment by 1
    And advertisement should be shown at my page

