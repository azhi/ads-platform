Feature: Going through all cycle from creating to publishing
  Background:
    Given there is a user "testuser", his email is "testmail@example.com" and his pwd is "foobar12"
    Given there is admin
    And there is a type "SomeType"

  Scenario:
    When I sign in as testuser, foobar12
    And I create advertisement "somecontent" with type "SomeType" and pic url "http://example.com/pic1.jpg"
    And I go to my page
    And I send to approval my advertisement
    And I sign out
    And I sign in as admin, foobar12
    And I go to list of moderated ads
    And I approve advertisement
    And sometime after rake task publishes all approved ads
    Then I should see ads "somecontent" with type "SomeType" on ads index
    And sometime after rake task archives all published ads
    Then I shouldn't see ads "somecontent" with type "SomeType" on ads index
