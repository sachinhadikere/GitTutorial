Feature: Articles

Background: Define preconditions
    * url apiUrl
    * def articleRequestBody = read("classpath:Json/NewArticleRequest.json")
    * def dataGenerator = Java.type('Helpers.DataGenerator') 
    * set articleRequestBody.article.title  = dataGenerator.getRandomArticleValues().title
    * set articleRequestBody.article.description  = dataGenerator.getRandomArticleValues().description
    * set articleRequestBody.article.body  = dataGenerator.getRandomArticleValues().body

@parallel=false
Scenario: Create and delete article
    Given path '/articles'
    And request articleRequestBody
    When method Post
    Then status 200
    And match response.article.title == articleRequestBody.article.title
    * def articleId = response.article.slug
    * print 'articleId--',articleId

    Given path '/articles'
    And params { limit: 10, offset: 0 }
    When method Get
    Then status 200
    And match response.articles[0].title == articleRequestBody.article.title
    And match response.articles[0].slug == articleId

    Given path '/articles/' + articleId
    When method Delete
    Then status 200

    Given path '/articles'
    And params { limit: 10, offset: 0 }
    When method Get
    Then status 200
    And match response.articles[0].title != articleRequestBody.article.title