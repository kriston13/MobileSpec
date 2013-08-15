require 'spec_helper'
#require 'support/register_support'


describe "The Registration process", :type => :feature, :js => true do

	valid_postcode = '3056'
	valid_suburb = 'Brunswick'
	invalid_postcode = '1111'
	invalid_suburb = 'Failburb'
	
	HD_suburb = 'Brunswick'
	HD_suburb_full = '3056 - Brunswick'
	CC_suburb = 'Brunswick Lower'
	CC_suburb_full = '3056 - Brunswick Lower'
	RD_suburb = 'Douglas Park'
	RD_suburb_full = '2569 - Douglas Park'
	
	storeURL = '/online/mobile/vic-metro-richmond'
	registerURL = '/online/mobile/vic-metro-richmond/register'

	registerFormURL ='/webapp/wcs/stores/servlet/m20UserRegistrationAddForm?catalogId=11601&langId=-1&storeId=10501'
	
	before :all do
		#page.driver.browser.set_proxy :host=> 'http://jtan3:passw0rd3@proxy.cmltd.net.au', :port=> 8080
	end
	
	it "begins with the suburb-postcode page" do
		visit(storeURL)

		click_link 'Register'
		
		page.should have_content 'Register'
		page.should have_content 'Where would you like your shopping delivered?'
		page.should have_content 'Suburb or post code'
		
	end

	it "requires input to enable the button" do
		visit(registerURL)
		
		page.should have_content 'Register'
		
		find_button('Continue', disabled:true)
		
		fill_in('Suburb or post code', :with => "A")

		find_button('Continue', disabled:true)
		
		fill_in('Suburb or post code', :with => "AB")
		
		find_button('Continue', disabled:true)
		
		fill_in('Suburb or post code', :with => "ABC")
		
		find_button('Continue')		
		
	end
	
	it "returns a list of suburbs given a valid postcode" do
	

		visit(registerURL)
		fill_in('Suburb or post code', :with => valid_postcode)
		
		click_button('Continue')
		
		page.has_no_button?('Continue')

		
		within("ul#suburbPostcodeResults") do
			all("li a").each do |link|
				link.has_text?(/.+#{valid_postcode}/)
			end
		end
		
	
	end
	
	it "tells me when it has no suggested suburb/postcodes" do
	
		visit(registerURL)
		fill_in('Suburb or post code', :with => invalid_suburb)
		
		click_button('Continue')
		
		page.should have_content(/Sorry, we can.t find that location/)
	
	end
	
	
	
	it "arrives on the registration page when I pick a HD location" do
	
		visit(registerURL)
		fill_in('Suburb or post code', :with => HD_suburb)

		click_button('Continue')
		
		#click_link(HD_suburb_full.upcase)
		
		Capybara.match = :prefer_exact
		find('span.heading',:text=>HD_suburb_full.upcase).click #attempting to find a link and then click it
		#Capybara.exact = false
		
		page.should have_content('Register')
		page.should have_content('Personal details')
		page.should have_content('Given name')
		page.has_checked_field?('Yes, please keep me up to date')
		page.should have_button('Register')
	
	end
	
	it "brings me to the RD screen when I give an RD location, then to registration" do
	
		visit(registerURL)
		
		fill_in('Suburb or post code', :with => RD_suburb)
		
		click_button('Continue')

		Capybara.exact = true
		find('span.heading',:text=>RD_suburb_full.upcase).click #attempting to find a link and then click it
		Capybara.exact = false
		
		page.should have_content('Remote Delivery')
		page.should have_content('Click & Collect')
	
		all('.storeList').first.all('li').first.find('a').click
		
		page.should have_content('Register')
		page.should have_content('Personal details')
	
	end
	
	it "brings me to the CC only screen when I give a location without RD or HD, then to registration" do
	
		visit(registerURL)
		
		fill_in('Suburb or post code', :with => CC_suburb)
		
		click_button('Continue')
		
		Capybara.exact = true
		find('span.heading',:text=>CC_suburb_full.upcase).click #attempting to find a link and then click it
		Capybara.exact = false
		
		page.should have_content('Click & Collect')
		
		page.should_not have_content('Remote Delivery')
	
		all('.storeList').first.all('li').first.find('a').click
		
		page.should have_content('Register')
		page.should have_content('Personal details')
	
	end
	
	
	
	it "should not let me go to the registration form directly" do
		#pending 'known problem'
		visit(registerFormURL)
		
		page.should_not have_content('Personal details')
		#screenshot_and_open_image
		#page.should have_content('Suburb or post code')
	
	end
	
	
	it "should have mandatory validation checks on the registration form" do

		go_to_registration_page_with_HD
		
		click_button('Register')
		
		#page.should have_content('Fail')
		page.should have_content('To continue please')
		page.should have_content('Your first name is required')
		page.should have_content('Your last name is required')
		page.should have_content('Please enter an email address')
		page.should have_content('Please enter a password')
		page.should_not have_content('This password does not match the password entered above')		
		
	end
	
	it "should have formatting validation checks on the registration form" do
	
		go_to_registration_page_with_HD
		
		fill_in('Given name', :with => '123')
		fill_in('Family name', :with => '456')
		
		page.select '31', :from => 'birthDay'
		page.select 'December', :from => 'birthMonth'
		page.select '2013', :from => 'birthYear'
		
		
		fill_in('Email address', :with => 'boom.com')
		fill_in('Create password', :with => 'short')
		fill_in('Confirm password', :with => 'not-the-same')
		
		click_button('Register')
		
		page.should have_content('Your first name can only contain')
		page.should have_content('Your last name can only contain')
		page.should have_content('You cannot select a date in the future')
		page.should have_content(/This email address doesn.t appear to be valid/)
		page.should have_content('Your password must be at least 6 characters long')
		page.should have_content('This password does not match the password entered above')

		
	
	end
	
	it "will allow a registration with valid details, and then a fresh log in" do
	
		go_to_registration_page_with_HD
		
		today_string = Time.now.asctime.gsub(/[\s\:]/,'_')
		email_address = 'rspec'+today_string+'HD@mailinator.com'
		#puts email_address
		fill_in('Given name', :with => 'Given')
		fill_in('Family name', :with => 'Name')
		
		page.select '11', :from => 'birthDay'
		page.select 'January', :from => 'birthMonth'
		page.select '1918', :from => 'birthYear'
		
		#fill_in('Date of birth', :with => '1989-01-01')
		fill_in('Email address', :with => email_address)
		fill_in('Create password', :with => 'passw0rd')
		fill_in('Confirm password', :with => 'passw0rd')
	
		click_button('Register')
		
		page.should have_content('My usuals and lists')
		
		page.driver.browser.manage.all_cookies.include? ":name=>\"canBrowseRestrictedProductsFlag\",:value=>\"1\""
		
		page.driver.browser.manage.all_cookies.include? ":name=>\"WC_PERSISTENT\""
		
	
		page.driver.browser.manage.delete_all_cookies
		
		visit(storeURL)
		
		page.should have_content('Log in')
		click_link('Log in')
		
		
		page.should have_content('Log in')
		page.should have_content('Email address')
		page.should have_content('Password')
	
		fill_in('Email address', :with => email_address)
		fill_in('Password', :with => 'passw0rd')
		
		
		click_button('Log in')
	
		page.should have_content('My usuals and lists')
	
		page.driver.browser.manage.all_cookies.include? ":name=>\"canBrowseRestrictedProductsFlag\",:value=>\"1\""
	
		!page.driver.browser.manage.all_cookies.include? ":name=>\"WC_PERSISTENT\""
	
	end
	
		it "lets me go to the national C&C screen before going to the registration page" do
	
		visit(registerURL)
		
		fill_in('Suburb or post code', :with => CC_suburb)
		
		click_button('Continue')

		Capybara.exact = true
		find('span.heading',:text=>CC_suburb_full.upcase).click #attempting to find a link and then click it
		Capybara.exact = false
		
		page.should have_content('Click & Collect')
		
		page.should_not have_content('Remote Delivery')
	
		click_link('View more Coles stores')
		
		page.should have_content('Click & Collect locations')
		
		page.should have_content('You can collect your shopping from any of these Coles stores in Victoria')	#should be victoria given provided CC location
		
		page.should have_content('View Coles stores in other states')
		
		page.has_select?('View Coles stores in other states', :selected => 'Victoria')
		
		arrival_link_title = all('.storeList').first.all('li').first.find('a')[:title]
		puts arrival_link_title
		
		page.select 'New South Wales', :from => 'View Coles stores in other states'
		
		changed_link_title = all('.storeList').first.all('li').first.find('a')[:title]
		puts changed_link_title
		
		arrival_link_title.should_not eq(changed_link_title)
		
		
		all('.storeList').first.all('li').first.find('a').click
		
		page.should have_content('Register')
		page.should have_content('Personal details')
	
	end
	
	it "displays the RD and CC descriptive text - found in defect 6666" do
		
		visit(registerURL)
		
		fill_in('Suburb or post code', :with => RD_suburb)
		
		click_button('Continue')

		Capybara.match = :prefer_exact
		find('span.heading',:text=>RD_suburb_full.upcase).click #attempting to find a link and then click it
#		Capybara.exact = false
			
		page.should have_content('Remote Delivery')
		page.should have_content('We can delivery to this locations') #known typos
		
		page.should have_content('Click & Collect')
		page.should have_content('You can collect your shopping from these Coles stores near you')
		
	end
	
	it "displays the server side error message in the appropriate location - found in defect 6665" do
	
		visit(registerURL)
		fill_in('Suburb or post code', :with => invalid_suburb)
		
		click_button('Continue')
		
		find('div.msg-box').should have_content(/Sorry, we can.t find that location/)
	
	end
	
	
	
end