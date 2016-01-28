step 'I want to order from Gousto' do
 visit 'https://www.gousto.co.uk/'
 find_first('a.gbtn-primary.gbtn--lg').click
 wait_for_ajax
 expect(page).to have_css('h4.dateselection-title')
end

step 'I add a meal to my basket' do
  all('a.dateselection-day-btn.col-sm-12')[2].click
  @initial_slot_numbers = all("li.ordersummary-recipe.placeholder").count
  find_first('a.addtobasket.plus').click
  expect(page).to have_css("div.ordersummary-recipe-overview")
  expect(all("li.ordersummary-recipe.placeholder").count).to be < @initial_slot_numbers
end

step 'I can add another portion of the same meal' do
  number_portions=find_first('p.pull-right').text.split.first.to_i
  find_first('a.ordersummary-recipe-double').click
  wait_for_ajax
  expect(find_first("p.pull-right").text.split.first.to_i).to be > number_portions
end

step 'I fill my basket' do
  step "I add a meal to my basket"
  step "I can add another portion of the same meal"
end

step 'I can go to checkout' do
  find('button.gbtn-primary.btn-block.ordersummary-submit-checkout-form').click
end

step 'fill out my personal details' do
  fill_in 'email', with: 'kj-brown@live.co.uk'
  fill_in 'checkoutpassword', with: 'password'
  select 'Mrs.', from: 'title'
  click_on "Next step"
  fill_in 'deliverypostcode', with: 'SW17 9EG'
  find('#deliverylookup').click
  select '38 Eastbourne Road, London', from: 'crafty_postcode_lookup_result_option1'
  select 'Front Porch', from: 'deliveryinstruction'
  fill_in 'phone', with: '07891445354'
  click_on "Next step"
end

step 'purchase the basket' do
  puts 'I am NOT putting my payment details in this code'
end

step 'I can remove a portion from my basket' do
  find('a.ordersummary-remove-recipe').click
  expect(all("li.ordersummary-recipe.placeholder").count).to eql(@initial_slot_numbers)
end

step 'I change the delivery date to the latest option' do
  num = all('a.dateselection-day-btn.col-sm-12').count
  all('a.dateselection-day-btn.col-sm-12')[0].click
end

step 'the recipe will change to the menu for next week' do
  wait_for_ajax
  expect(current_path).to eql("/next-weeks-recipes")
  expect(page).to have_content('PREVIOUS MENU')
end

step 'I will lose recipes from the previous week' do
  wait_for_ajax
  expect(page).to have_css('p.alertify-message')
  click_on 'alertify-ok'
  wait_for_ajax
  expect(all("li.ordersummary-recipe.placeholder").count).to eql(@initial_slot_numbers)
end