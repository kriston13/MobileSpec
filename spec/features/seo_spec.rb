require 'spec_helper'


describe "The Site has SEO URLs that", :type => :feature, :js => true do

	context_root = '/webapp/wcs/stores/servlet'

	vic_metro_brunswick_store = '/mobile/vic-metro-brunswick'
	nsw_metro_hornsby_store = '/mobile/nsw-metro-hornsby'

	login_seo = '/logon'
	register_seo = '/register'
	
	homepage_text = 'coles online'

	it "leads to the home page" do
		
		visit(context_root+vic_metro_brunswick_store)
		page.should have_content(homepage_text)
		
		visit(context_root+nsw_metro_hornsby_store)
		page.should have_content(homepage_text)
	
	end
	
	it "leads to the logon page" do
		
		visit(context_root+vic_metro_brunswick_store+login_seo)
		page.should have_content('Log in')
		page.should have_content('Email address')
		page.should have_content('Password')
		
	end

	it "leads to the register page" do
		visit(context_root+vic_metro_brunswick_store+register_seo)
		page.should have_content('Register')
		page.should have_content('Where would you like your shopping delivered?')
		page.should have_content('Suburb or post code')
		
	end
	
	it "leads to the list of aisles" do
		visit(context_root+vic_metro_brunswick_store+'/aisles')
		page.should have_content('Categories')
		page.should have_content('International Food')
		page.should have_content('Clothing')
		page.should have_content('Household')
		
	end
	
	it "leads to the list of categories in an aisle" do
		visit(context_root+vic_metro_brunswick_store+'/international-food')
		page.should have_content('International Food')
		page.should have_content('Cuisine')
	
	end
	
	
	it "leads to the list of subcategories in a category" do
		visit(context_root+vic_metro_brunswick_store+'/international-food/cuisine')
		page.should have_content('Cuisine')
		page.should have_content('Indian')
		page.should have_content('Asian')
		page.should have_content('European')
		page.should have_content('Mexican')
		
	end
	
	it "leads to the list of products within a subcategory" do
		visit(context_root+vic_metro_brunswick_store+'/international-food/cuisine/mexican')
		page.should have_content('Mexican')
		all('.productListItem').length == 10
	end
	
	it "leads to a product without parent categories" do
		visit('http://localhost/webapp/wcs/stores/servlet/mobile/vic-metro-richmond/steggles-chicken-mince')
		page.should have_content('Chicken Mince')
		page.should have_content('Steggles')
		
	end
	
	it "leads to a product WITH parent categories" do
		visit('http://localhost/webapp/wcs/stores/servlet/mobile/vic-metro-richmond/bread-bakery/fresh/bread/buttercup-country-split-bread-wmeal')
		page.should have_content('Bread Wmeal')
		page.should have_content('Buttercup Country Split')
	
	end
	
end