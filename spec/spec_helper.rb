# Setup Capybara so that we can use the DSL for writing the tests
require 'rubygems'
require 'capybara'
require 'bundler/setup'
require 'capybara/rspec'
#require 'capybara/poltergeist'
require 'launchy'

require 'capybara-webkit'
require 'capybara-screenshot'
require 'capybara-screenshot/rspec'


RSpec.configure do |config|
	config.include Capybara::DSL
end

Dir["./support/**/*.rb"].sort.each {|f| require f}

#Capybara.register_driver :poltergeist do |app|
#	Capybara::Poltergeist::Driver.new(app, {:phantomjs=>'C:\phantomjs\phantomjs.exe', :phantomjs_options => ['--ignore-ssl-errors=yes'], :logger => nil})
#end

# We will use the poltergeist driver
#Capybara.default_driver = :poltergeist

#Capybara.javascript_driver = :poltergeist

# Capybara.register_driver :selenium_iphone do |app|
	# require 'selenium/webdriver'
	# profile = Selenium::WebDriver::Firefox::Profile.new
	# profile['general.useragent.override'] = 'iPhone'
	
	# Capybara::Selenium::Driver.new(app, :profile => profile)
# end

# Capybara.default_driver = :selenium_iphone
# Capybara.javascript_driver = :selenium_iphone

Capybara.default_driver = :selenium
Capybara.javascript_driver = :selenium

#Capybara.default_driver = :webkit
#Capybara.javascript_driver = :webkit

# We will not run our own server; we will connect to a remote server
Capybara.run_server = false

# Set the base URL for all our tests
Capybara.app_host = 'http://localhost'
#Capybara.app_host='http://udecommwcs1.cmltd.net.au:27905'

Capybara.save_and_open_page_path = './tmp/capybara'

Capybara.default_wait_time=5

#Capybara.ignore_hidden_elements=false

