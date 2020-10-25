Feature: Articles

  Background: Define Url
    Given url apiUrl

    @debug
    Scenario: Create a new article
      Given path 'articles'
      And request
      """
        {
            "article": {
            "tagList": [],
            "title": "Victorio",
            "description": "victorio-l6lq3m",
            "body": "Lo mejor de lo mejor"
            }
        }
      """
      When method POST
      Then status 200
      And match response.article.title == 'Victorio'

  Scenario: Create a delete article
    Given path 'articles'
    And request
      """
        {
            "article": {
            "tagList": [],
            "title": "Delete Article",
            "description": "victorio-l6lq3m",
            "body": "Lo mejor de lo mejor"
            }
        }
      """
    When method POST
    Then status 200
    * def articleId = response.article.slug

    Given params { limit: 10, offset: 0}
    Given path 'articles'
    When method GET
    Then status 200
    And match response.articles[0].title == 'Delete Article'

    Given path 'articles',articleId
    When method DELETE
    Then status 200

    Given params { limit: 10, offset: 0}
    Given path 'articles'
    When method GET
    Then status 200
    And match response.articles[0].title != 'Delete Article'
