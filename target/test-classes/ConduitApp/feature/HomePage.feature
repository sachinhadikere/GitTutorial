
Feature: Tests for Home Page 

Background:
    * url apiUrl
    * def isValidTime =  read('classpath:Helpers/timeValidator.js')

@sanity
Scenario: Get all Tags
    Given path '/tags'
    When method Get
    Then status 200
    And match response == '#object'
    And match response.tags == '#array'     
    And match response.tags != '#string'
    And match each response.tags contains '#string'
   # And match response.tags contains ('implementations','introduction','codebaseShow')
  #  And match response.tags contains any ['car','bike','welcome']  //validate any one value from list to be present
  #  And match response.tags !contains ['car']
    And match response.tags == '#[4]'

Scenario: Get all articles
    Given path '/articles'
    And params { limit: 10, offset: 0 }
    When method Get
    Then status 200
    And match response == {"articles": '#array', "articlesCount": 5}
    And match response.articles == '#[5]' //number of array inside articles
    And match response.articles[*].tagList[*] contains 'implementations'
    And match response..tagList[0] contains 'implementations'

    #And match each response.articles[*].author.following == false
    #And match each response..following != true
    And match each response..following == '#boolean'

    #And match response.articlesCount == 5
    And match response.articlesCount == '#number'

    And match each response..bio == '##string' //validate each bio value should be string or anything
    And match each response..bio == '#present' //validate bio key maust be present with any type of value including null
    And match each response..gio == '##number' //if key present then validates for value else ignores the key

    #validate schema
    And match each response.articles ==
    """
        {
            "slug": "#string",
            "title": "#string",
            "description": "#string",
            "body": "#string",
            "tagList": '#array',
            "createdAt": '#? isValidTime(_)',
            "updatedAt": '#? isValidTime(_)',
            "favorited": '#boolean',
            "favoritesCount": '#number',
            "author": {
                "username": "#string",
                "bio": "##string",
                "image": "#string",
                "following": '#boolean'
            }
        }
    """

