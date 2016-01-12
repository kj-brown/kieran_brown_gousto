Given(/^I want to order from Gousto$/) do
 visit 'https://www.gousto.co.uk/'
 find_first('a.gbtn-primary.gbtn--lg').click
 wait_for_ajax
 expect(page).to have_css('h4.dateselection-title')
end

When(/^I add a meal to my basket$/) do
  @initial_slot_numbers = all("li.ordersummary-recipe.placeholder").count
  find_first('a.addtobasket.plus').click
  expect(page).to have_css("div.ordersummary-recipe-overview")
  expect(all("li.ordersummary-recipe.placeholder").count).to be < @initial_slot_numbers
end

Then(/^I can add another portion of the same meal$/) do
  number_portions=find_first('p.pull-right').text.split.first.to_i
  find('a.ordersummary-recipe-double').click
  expect(find_first("p.pull-right").text.split.first.to_i).to be > number_portions
  
 # require 'pry'
 # binding.pry
end

When(/^I fill my basket$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I can go to checkout$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^fill out my personal details$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^purchase the basket$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I can remove a portion from my basket$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I change the delivery date to the latest option$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^the recipe will change to the menu for next week$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I will lose recipes from the previous week$/) do
  pending # express the regexp above with the code you wish you had
end
# find_first("[data-iscurrent='false']")