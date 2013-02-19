Feature: Creating advertisement for signed in user
  Background:
    Given I am admin

  Scenario:
    When I create a type "SomeType"
    Then A type count should increment by 1
