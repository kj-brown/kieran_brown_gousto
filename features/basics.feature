Feature: Gousto Test
As a Test Automation Person
I want to run the basic flow
So I can test the weird stuff

Scenario: Main Flow
Given I want to order from Gousto
When I fill my basket
Then I can go to checkout
And fill out my personal details
And purchase the basket

Scenario: Doubling portions
Given I want to order from Gousto
When I add a meal to my basket
Then I can add another portion of the same meal

Scenario: Deleting portions
Given I want to order from Gousto
When I add a meal to my basket
Then I can remove a portion from my basket

Scenario: Changing Menu
Given I want to order from Gousto
When I change the delivery date to the latest option
Then the recipe will change to the menu for next week

Scenario: Changing Menu removes already selected recipes
Given I want to order from Gousto
When I add a meal to my basket
And I change the delivery date to the latest option
Then I will lose recipes from the previous week
