Feature: Create Token

  Scenario: Create Token
    Given url apiUrl
    Given path 'users/login'
    And request {"user": {"email": "#(userEmail)","password": "#(userPassword)"}}
    When method POST
    Then status 200
    * def authtoken = response.user.token