require 'rails/all'
require 'capybara/dsl'
require 'capybara/rspec'
require 'turnip'
require 'turnip/capybara'
require 'appium_lib'
require 'appium_capybara' 
require 'minitest'

RSpec.configure do |config|

#This selects which driver we're going to test with.
  config.before(:each) do
    if ENV['AUTOMATION_DRIVER'] == 'ios'
      Capybara.current_driver = :appium_ios
    elsif ENV['AUTOMATION_DRIVER'] == 'selenium'
      Capybara.current_driver = :selenium
      Capybara.run_server = false    
    elsif ENV['AUTOMATION_DRIVER'] == 'sauce'
      Capybara.current_driver = :sauce
      Capybara.javascript_driver = :sauce
    else
      require 'capybara/poltergeist'
      Capybara.current_driver = :poltergeist_headless
      Capybara.javascript_driver = :poltergeist_headless
      Capybara.server_port    = 8081
    end


#This decides the environment you wish to test against.
    if ENV['ENVIRONMENT'] == 'staging'
      Capybara.app_host = "https://#{ENV['BASIC_AUTH_USERNAME']}:#{ENV['BASIC_AUTH_PASSWORD']}@staging.sticky9.com"
    elsif ENV['ENVIRONMENT'] == 'development'
      Capybara.app_host = "https://#{ENV['BASIC_AUTH_USERNAME']}:#{ENV['BASIC_AUTH_PASSWORD']}@dev.sticky9.com"
    elsif ENV['ENVIRONMENT'] == '3000'
      Capybara.app_host = "http://localhost:3000"
    else 
      Capybara.app_host = "http://localhost:8080"
    end
  end



#This is an example of omitting a tag from a test run. To include the tag, either delete it or set it to true
  config.filter_run_excluding test: true
  config.filter_run_excluding wip: true

  config.expect_with :rspec do |c| 
    c.syntax = [:should, :expect] 
  end

  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

Dir.glob("spec/features/step_definitions/**/*steps.rb") { |f| load f, true }


# The settings below are suggested to provide a good initial experience
# with RSpec, but feel free to customize to your heart's content.
=begin
  # These two settings work together to allow you to limit a spec run
  # to individual examples or groups you care about by tagging them with
  # `:focus` metadata. When nothing is tagged with `:focus`, all examples
  # get run.
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  # Limits the available syntax to the non-monkey patched syntax that is
  # recommended. For more details, see:
  #   - http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax
  #   - http://teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
  #   - http://myronmars.to/n/dev-blog/2014/05/notable-changes-in-rspec-3#new__config_option_to_disable_rspeccore_monkey_patching
  config.disable_monkey_patching!
  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end
  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  config.profile_examples = 10
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random
  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed
=end

end

Capybara.add_selector(:uuid) do
  xpath { |name| XPath.css("[data-uuid='#{name}']") }
end
 

def find_uuid(name)
  find(:uuid, name)
end

def click_uuid(name)
  if Capybara.current_driver == :poltergeist_headless
    find_uuid(name).trigger('click')
  else
    find_uuid(name).click
  end
end

def find_first(selector)
  page.first(selector) if find(selector, match: :first)
end


Capybara.default_max_wait_time = 15
Capybara.default_selector = :css



port = 44678

Capybara.register_driver :poltergeist_headless do |app|
    Capybara::Poltergeist::Driver.new(app, { :debug => false, :port => port,:resynchronize => false, :resynchronization_timeout => 1000, timeout: 180, phantomjs_logger: StringIO.new, logger: nil, :phantomjs_options => ['--load-images=no', '--ignore-ssl-errors=yes'], js_errors: false})
end

Capybara.register_driver :appium_ios do |app|
    capabilities = {:platformName => 'iOS', :platformVersion => '8.1', :deviceName=> 'iPhone 6', :browserName => 'Safari', :version => '6.0', :nativeWebTap => false, :safariIgnoreFraudWarning => true}
Appium::Capybara::Driver.new(app,
                                 :browser => :remote,
                                 :caps => capabilities,
                                 :url => "http://0.0.0.0:4723/wd/hub"
                                 )
end  