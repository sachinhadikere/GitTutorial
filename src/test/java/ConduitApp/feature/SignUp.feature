
Feature: SignUp new User

Background: 
    * url apiUrl
    * def userData = Java.type('Helpers.DataGenerator')
    * def email = userData.getRandomEmail()
    * def username = userData.getRandomUsername()

Scenario: SignUp
    Given path '/users'
    And request
    """
        {
           "user": {
               "email": '#(email)',  
               "password": "pass1234",
               "username": '#(username)'
            }
        }
    """
    When method Post
    Then status 200
    And match response.user.email == email
    And match response == 
    """
        {
           "user": {
              "email": #(email),
              "username": '#(username)',
              "bio": null,
              "image": "#string",
              "token": "#string"
            }
        }
    """
@sanity
Scenario Outline: Validate SignUp error messages
    Given path '/users'
    And request
    """
        {
           "user": {
               "email": '<email>',  
               "password": '<password>',
               "username": '<username>'
            }
        }
    """
    When method Post
    Then status 422
    And match response == <response>

    Examples:
    | email              | password | username    | response                                                                              |
    | testapi1@gmail.com | pass1234 | testapi1    | {"errors":{"email":["has already been taken"],"username":["has already been taken"]}} |
    | #(email)           | pass1234 | testapi1    | {"errors":{"username":["has already been taken"]}}                                    |
    | testapi1@gmail.com | pass1234 | #(username) | {"errors":{"email":["has already been taken"]}}                                       |
    |                    | pass1234 | #(username) | {"errors":{"email":["can't be blank"]}}                                               |
    | #(email)           | pass1234 |             | {"errors":{"username":["can't be blank"]}}                                            |
    | #(email)           |          | #(username) | {"errors":{"password":["can't be blank"]}}                                            |