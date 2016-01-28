# You should edit this file with the browsers you wish to use
# For options, check out http://saucelabs.com/docs/platforms
require "sauce"
require 'capybara/rails'
require 'capybara/rspec'
require "sauce/capybara"
require 'spec_helper'

Sauce.config do |config|
  config[:browsers] = [
    ["Windows 8", "Internet Explorer", "10"]
  ]
  config[:sauce_connect_4_executable] = "~/sc-4.3.8-osx/bin/sc"
end