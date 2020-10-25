Feature: Add Likes

  Background:
    * url apiUrl

    Scenario: Add Likes
      Given path 'articles', slug, 'favorite'
      And request {}
      When method POST
      * def likesCount = response.article.favoritesCount
