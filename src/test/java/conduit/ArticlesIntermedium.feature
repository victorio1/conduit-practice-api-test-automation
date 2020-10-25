Feature: Articles

  Background: Define Url
    * url apiUrl
    * def articleRequestBody = read('classpath:conduit/json/newArticleRequest.json')
    * def dataGenerator = Java.type('conduit.helpers.DataGenerator')
    * set articleRequestBody.article.title = dataGenerator.getRandomArticleValues().title
    * set articleRequestBody.article.description = dataGenerator.getRandomArticleValues().description
    * set articleRequestBody.article.body = dataGenerator.getRandomArticleValues().body

  @debug
  Scenario: Create a new article
    Given path 'articles'
    And request articleRequestBody
    When method POST
    Then status 200
    And match response.article.title == articleRequestBody.article.title

  Scenario: Create a delete article
    Given path 'articles'
    And request articleRequestBody
    When method POST
    Then status 200
    * def articleId = response.article.slug

    Given params { limit: 10, offset: 0}
    Given path 'articles'
    When method GET
    Then status 200
    And match response.articles[0].title == articleRequestBody.article.title

    Given path 'articles',articleId
    When method DELETE
    Then status 200

    Given params { limit: 10, offset: 0}
    Given path 'articles'
    When method GET
    Then status 200
    And match response.articles[0].title != articleRequestBody.article.title
