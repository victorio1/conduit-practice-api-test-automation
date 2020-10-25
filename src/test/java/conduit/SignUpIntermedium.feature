Feature: Sign Up new user Intermedium

  Background: Preconditions
    Given url apiUrl
    * def dataGenerator = Java.type('conduit.helpers.DataGenerator')
    * def timeValidator = read('classpath:conduit/helpers/timeValidator.js')
    * def randomEmail = dataGenerator.getRandomEmail()
    * def randomUsername = dataGenerator.getRandomUsername()

    @debug
    Scenario: New user Sign Up Test 1
      * def jsFunction =
      """
        function () {
          var DataGenerator = Java.type('conduit.helpers.DataGenerator')
          var generator = new DataGenerator()
          return generator.getRandomUsername2()
        }
      """
      * def getRandomUsername2 = call jsFunction
      Given path 'users'
      And request
      """
               {
                  "user": {
                      "email": "#(randomEmail)",
                      "password": "victori312",
                      "username": "#(getRandomUsername2)"
                  }
               }
      """
      When method POST
      Then status 200
      And match response ==
      """
        {
          "user": {
            "id": "#number",
            "email": "#(randomEmail)",
            "createdAt": "#? timeValidator(_)",
            "updatedAt": "#? timeValidator(_)",
            "username": "#(getRandomUsername2)",
            "bio": null,
            "image": null,
            "token": "#string"
              }
        }
      """

      @parallel=false
      Scenario Outline: Validate Sign Up error messages
        Given path 'users'
        And request
          """
            {
              "user": {
                 "email": "<email>",
                 "password": "<password>",
                 "username": "<username>"
              }
            }
          """
        When method POST
        Then status 422
        And match response == <errorResponse>

        Examples:
          |email               |password | username              | errorResponse                                                                       |
          |#(randomEmail)      |Karate123| KarateUser123         | {"errors": {"username": ["has already been taken"]}}                                |
          |KarateUser1@test.com|Karate123| #(getRandomUsername)  | {"errors": {"email": ["has already been taken"]}}                                   |
          |KarateUser1         |Karate123| #(getRandomUsername)  | {"errors": {"email": ["is invalid"]}}                                               |
          |#(randomEmail)      |Karate123| KarateUser123123123123| {"errors": {"username": ["is too long (maximum is 20 characters)"]}}                |
          |#(randomEmail)      |Kar      | #(getRandomUsername)  | {"errors": {"password": ["is too short (minimum is 8 characters)"]}}                |
          |                    |Karate123| #(getRandomUsername)  | {"errors": {"email": ["can't be blank"]}}                                           |
          |#(randomEmail)      |         | #(getRandomUsername)  | {"errors": {"password": ["can't be blank"]}}                                        |
          |#(randomEmail)      |Karate123|                       | {"errors": {"username": ["can't be blank","is too short (minimum is 1 character)"]}}|