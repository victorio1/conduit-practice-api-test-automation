Feature: Dummy

  Scenario: Dummy
    * def dataGenerator = Java.type('conduit.helpers.DataGenerator')
    * def username = dataGenerator.getRandomUsername()
    * print username