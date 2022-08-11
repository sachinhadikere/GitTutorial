Feature: Token generate

Background:
    * url apiUrl

Scenario: login and get token
    Given path '/users/login'
    And request {"user":{"email": "#(UserEmail)", "password": "#(Password)"}}
    When method Post
    Then status 200
    * def authToken = response.user.token