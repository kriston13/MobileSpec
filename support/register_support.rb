require 'spec_helper'


def go_to_registration_page_with_HD

	visit('/webapp/wcs/stores/servlet/ColesMobileSelectSuburbForm?catalogId=11601&langId=-1&storeId=10501')
	fill_in('Suburb or post code', :with => 'Brunswick')

	click_button('Continue')
	
	Capybara.exact = true
	find('span.heading',:text=>'3056 - Brunswick'.upcase).click #attempting to find a link and then click it
	Capybara.exact = false

	page.should have_content('Register')
	
end