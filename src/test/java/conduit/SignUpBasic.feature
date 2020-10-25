Feature: Sign Up new user Basic

  Background: Preconditions
    Given url apiUrl
    * def dataGenerator = Java.type('conduit.helpers.DataGenerator')

    Scenario: New user Sign Up Test 2
      Given def userData = {"email":"papu334@scotiabank.com.pe","username":"eduardi5587"}
      Given path 'users'
      And request
      """
         {
            "user": {
                "email": "#('Test'+userData.email)",
                "password": "victori312",
                "username": "#('User'+userData.username)"
            }
         }
      """
      When method POST
      Then status 200