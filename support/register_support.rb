require 'spec_helper'


def go_to_registration_page_with_HD

	visit('/webapp/wcs/stores/servlet/ColesMobileSelectSuburbForm?catalogId=11601&langId=-1&storeId=10501')
	fill_in('Suburb or post code', :with => 'Brunswick')

	click_button('Continue')
	
	click_link('3056 - Brunswick'.upcase)

	page.should have_content('Register')
	
end