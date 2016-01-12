require 'rspec/expectations'
require 'capybara/cucumber'

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end


Capybara.default_driver    = :selenium
Capybara.current_driver = :selenium
  
Capybara.default_selector = :css
World(RSpec::Matchers)

browser = Capybara.current_session.driver

def find_first(selector)
  page.first(selector) if find(selector, match: :first)
end

def wait_for_ajax
  Timeout.timeout(Capybara.default_max_wait_time) do
    active = page.evaluate_script('jQuery.active')
    until active == 0
      active = page.evaluate_script('jQuery.active')
    end
  end
end
