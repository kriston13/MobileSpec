require 'spec_helper'
#require 'support/register_support'

basic_richmond = '/online/mobile/vic-metro-richmond'

tester = 'rspectester-generic@mailinator.com'
password = 'passw0rd'

describe "Complex catentries", :type => :feature, :js => true do

	it "can be a Multi SKU multibuy" do
		visit(basic_richmond+'/logon')
		fill_in('Email address', :with => tester)
		fill_in('Password', :with => password)
		click_button ('Log in')
		
		fill_in('searchTerm', :with => 'onion')
		find_field('searchTerm').native.send_key(:enter)
		
		#puts all('div.multi')[0]
		
		multi_sku=all('div.multi')[0]
		multi_sku.find('a.available').text == "Choose any 2 for $1.50"
		#should have_content('Choose any 2 for $1.50')
		
		multi_sku.click_link('Choose any 2 for $1.50')
		
		page.should have_content('Buy 2 Onions for $1.50')
		
		all('div.special').length == all('div.productListItem').length
		
		all_specials = all('button.shoppingButton')
		
		all_specials[0].click_button('Add')
		all_specials[1].click_button('Add')
		
		find('div.trolleyPanel div.clickable').click
		
		page.should have_content('Your trolley')
		page.should have_content('2 items')
		
		
	end
	
	it "can be a Single SKU multibuy" do
		pending "steps to be filled in"
	end
	
	
end
