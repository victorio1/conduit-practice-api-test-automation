Feature: Tests for the home page

    Background: Define URL
      Given url apiUrl

    @regresion
    Scenario: Get all tags Test 1
      Given path 'tags'
      When method GET
      Then status 200
      And match response.tags contains ['HITLER','Gandhi']
      And match response.tags !contains 'truck'
      And match response.tags == "#array"
      And match each response.tags == "#string"

    @regresion
    Scenario: Get all tags Test 2
      Given path 'tags'
      When method GET
      Then status 200
      And match response.tags == "#array"
      And match each response.tags == "#string"

    Scenario: Get all tags Test 3
      Given path 'tags'
      When method GET
      Then status 200
      And match response.tags contains ['HITLER','Gandhi']
      And match response.tags !contains 'truck'
      And match response.tags contains any ['Gandhi','HITLER','BlackLivesMatter']
      And match response.tags == "#array"
      And match each response.tags == "#string"

    Scenario: Get 10 articles from the page test 1
      Given params { limit: 10, offset: 0}
      Given path 'articles'
      When method GET
      Then status 200
      And match response.articles == '#[10]'
      And match response.articlesCount == 500
      And match response.articlesCount != 100
      And match response == { "articles" : "#array", "articlesCount": 500 }
      And match response.articles[0].createdAt contains '2020'
      And match response.articles[*].favoritesCount contains 1
      And match response.articles[*].author.bio contains null
      And match response..bio contains null
      And match each response..following == false
      And match each response..following == '#boolean'
      And match each response..favoritesCount == '#number'
      And match each response..bio == '##string'

    Scenario: Get 10 articles from the page test 2
      * def timeValidator = read('classpath:conduit/helpers/timeValidator.js')
      Given params { limit: 10, offset: 0}
      Given path 'articles'
      When method GET
      Then status 200
      And match response.articles == '#[10]'
      And match response.articlesCount == 500
      And match response == { "articles" : "#array", "articlesCount": 500 }
      And match each response.articles ==
      """
        {
            "title": "#string",
            "slug": "#string",
            "body": "#string",
            "createdAt": "#? timeValidator(_)",
            "updatedAt": "#? timeValidator(_)",
            "tagList": "#array",
            "description": "#string",
            "author": {
                "username": "#string",
                "bio": '##string',
                "image": "#string",
                "following": '#boolean'
            },
            "favorited": '#boolean',
            "favoritesCount": '#number'
        }
      """

      Scenario: Conditional Logic
        Given params { limit: 10, offset: 0}
        Given path 'articles'
        When method GET
        Then status 200
        * def favoritesCount = response.articles[0].favoritesCount
        * def article = response.articles[0]

        * if (favoritesCount == 0) karate.call('classpath:conduit/helpers/AddLikes.feature', article)

        * def result = favoritesCount == 0 ? karate.call('classpath:conduit/helpers/AddLikes.feature', article).likesCount : favoritesCount

        Given params { limit: 10, offset: 0}
        Given path 'articles'
        When method GET
        Then status 200
        And match response.articles[0].favoritesCount == 1