require 'spec_helper'
#require 'support/register_support'


describe "The catalog", :type => :feature, :js => true do

	brunswick_store = '10501'
	brunswick_catalog = '11601'
	
	richmond_store = '10501'
	richmond_catalog = '12629'
	
	langId = '-1'
	
	brunswick_url= '/webapp/wcs/stores/servlet/mobile/vic-metro-brunswick'
	richmond_url = '/webapp/wcs/stores/servlet/mobile/vic-metro-richmond'
	hornsby_url = '/online/mobile/nsw-metro-hornsby'
	
	aisle_one = 'Pantry'
	category_one_one = 'Sauces'
	category_one_two = 'Baking'
	subcategory_one_one_one = 'Stir-fry and Curries'
	subcategory_one_two_one = 'Cake Decorating'
	
	aisle_two = 'International Food'
	category_two_one = 'Cuisine'
	subcategory_two_one_one = 'Indian'
	subcategory_two_one_two = 'Asian'
	
	aisle_tobacco = 'Tobacco'
	category_tobacco_one = 'Tobacco'
	subcategory_tobacco_one = 'Cigars'
	subcategory_tobacco_two = 'Loose Tobacco'
	
	user_email_no_dob = 'rspectester-no-dob@mailinator.com'
	user_email_too_young = 'rspectester-too-young@mailinator.com'
	user_email_old_enough = 'rspectester-old-enough@mailinator.com'
	password = 'passw0rd'
	
	
	tobaccoURLs = ['http://localhost/webapp/wcs/stores/servlet/m20CategoriesDisplayView?catalogId=12629&top_category=45559&parent_category_rn=45559&langId=-1&categoryId=60476&storeId=10501&browseView=true','http://localhost/webapp/wcs/stores/servlet/m20CatalogSearchResultView?catalogId=12629&top_category=&parent_category_rn=45559&langId=-1&categoryId=64987&storeId=10501&browseView=true',
	'http://localhost/webapp/wcs/stores/servlet/mobile/vic-metro-richmond/tobacco',
	'http://localhost/webapp/wcs/stores/servlet/mobile/vic-metro-richmond/tobacco/tobacco-60476',	'http://localhost/webapp/wcs/stores/servlet/m20ProductDisplayView?storeId=10501&parent_category_rn=60476&productId=15351&urlRequestType=Base&categoryId=64987&top_category=45559&langId=-1&catalogId=12629']
	
	
	it "has a menu to browse aisles, categories, and subcategories" do
	
		visit(richmond_url)
		
		page.should have_content('Shop by category')
		click_link 'Shop by category'
		
		page.should have_content('Categories') #mCAT_300
		
		page.should have_content(aisle_one)
		page.should have_content(aisle_two)
		page.should have_content('Entertainment')
		page.should have_content('Pet')
		page.should have_content('Tobacco')
		page.should have_content('Alcohol')
		page.should have_content('Specials')
		page.should have_content('Seasonal Aisle')
	
		click_link aisle_one #mCAT_400 - category
		page.should have_content(aisle_one)
		page.should have_content(category_one_one)
		page.should have_content(category_one_two)
		page.save_screenshot('aisle_one.png')
		click_link category_one_one	#mCAT_400 - subcategory
		page.should have_content(subcategory_one_one_one)
		click_link 'Back'
		
		page.should have_content('Categories') #mCAT_300
		
		click_link aisle_two #mCAT_400
		page.should have_content(aisle_two)
		page.should have_content(category_two_one)
		
		click_link 'Back'
		
		page.should have_content('Categories') #mCAT_300
		
	end
	
	
	it "has a product list you arrive at from the subcategory menu" do
		
		visit(richmond_url)
		click_link 'Shop by category'
		click_link 'Personal Care'
		click_link 'Skin Care'
		click_link 'Face Moisturizer'
		all('.productListItem').length > 0
		
	end
	
	it "has a product list that can be faceted" do
		visit(brunswick_url)
		click_link 'Shop by category'
		click_link 'Drinks'
		click_link 'Cold'
		click_link 'Long-Life Milk'
		all('.productListItem').length == 10
		page.should have_content('Filter')
		page.has_select?('Sort search results', :selected => 'Sort by A-Z (Brand)')
		
		click_link 'Filter'
		page.should have_content('Filter by')
		page.should have_content('Brand')
		
		click_link 'Devondale Long Life'
		
		page.should_not have_content('Filter by')
		page.should have_content('Devondale Long Life')
		page.should have_content('Remove')
		
		
	end
	
	it "can be searched and paged" do
		visit(brunswick_url)
		fill_in('searchTerm', :with => 'chicken')
		find_field('searchTerm').native.send_key(:enter)
		
		all('.productListItem').length == 10
		page.has_select?('Sort search results', :selected => 'Sort by relevance')
		page.should have_content('1 of 4')
		find('#mPrevPage.disabled')
		find('#mNextPage')
		firstPage = all('.productListItem')[0].find('p.name').text
		puts firstPage
		click_link 'mNextPage'
		
		secondPage = all('.productListItem')[0].find('p.name').text
		puts secondPage
		firstPage != secondPage
				
		page.should have_content('2 of 4')
		find('#mPrevPage')
		
		click_link 'mNextPage'
		
		thirdPage = all('.productListItem')[0].find('p.name').text
		puts thirdPage
		thirdPage != secondPage
		
		page.should have_content('3 of 4')
		
		click_link 'mNextPage'
		fourthPage = all('.productListItem')[0].find('p.name').text
		puts fourthPage
		
		fourthPage != thirdPage
		
		page.should have_content('4 of 4')
		find('#mPrevPage')
		find('#mNextPage.disabled')
		
		click_link 'mPrevPage'
		
		click_link 'mPrevPage'
		
		page.should have_content('2 of 4')
		all('.productListItem')[0].find('p.name').text == secondPage
		
	end
	
	it "can be searched, sorted and faceted" do
	
		visit(richmond_url)
		
		
		fill_in('searchTerm', :with => 'cheese')
		find_field('searchTerm').native.send_key(:enter)
		
		page.has_select?('Sort search results', :selected => 'Sort by relevance')
		
		click_link 'Filter'
		
		page.should have_content('Filter by')
		page.should have_content('Category')
		all('a.action-show-all-facets')[0].click
		
		
		page.should have_content('Brand')
	
		click_link 'Dairy, Eggs, Meals(50)'
		
		page.should have_content('cheese')
		page.should have_content('Dairy, Eggs, Meals')
		page.should have_content('Remove')
		
		find('#mNextPage')
		
		page.select 'Sort by lowest unit price first', :from => 'orderBy'
		
		page.should have_content 'cheese'
	
		page.has_select?('Sort search results', :selected => 'Sort by lowest unit price first')
		
		click_link 'Filter'
		
		click_link 'Cracker Barrel Dairy'
		
		page.should have_content 'cheese'
		
		page.should have_content 'Dairy, Eggs, Meals, Cracker Barrel Dairy'
		page.has_select?('Sort search results', :selected => 'Sort by lowest unit price first')
		
		click_link 'Remove'
		
		page.should have_content 'cheese'
		page.has_select?('Sort search results', :selected => 'Sort by lowest ubnit price first')
		
		
	end
	
	
	it "has a floating footer while browsing the menu, product list, and searching" do
		
		visit(hornsby_url)
		page.find('div.staticFooter')
		page.should have_content('Full website')
		page.should have_content('Provide feedback')
		
		fill_in('searchTerm', :with => 'cheese')
		find_field('searchTerm').native.send_key(:enter)
		
		#page.find('div.floatingFooter')
		page.should have_css('div.floatingFooter') #after a search
		
		click_link 'Shop by category'
		page.find('div.floatingFooter') #shop by category
		page.should have_content('Your current order:')
		page.should have_content('Reserve a delivery slot')
		
		click_link 'Pantry'
		page.find('div.floatingFooter') #/<aisle> - clicked 'Pantry'
		
		click_link 'Baking'
		#page.should have_css('div.floatingFooter') #/<aisle>/<category> - clicked 'Baking'
		#page.find('div.floatingFooter') #/<aisle>/<category> - clicked 'Baking'
		
		click_link 'Cake Decorating'
		#page.find('div.floatingFooter') #/<aisle>/<category>/<subcategory> - clicked 'Cake Decorating'
		page.should have_css('div.floatingFooter') #/<aisle>/<category>/<subcategory> - clicked 'Cake Decorating'
		
		find('.productSummary', :text => 'Cake Paste Almond Flavour').click
		#click_link 'Cake Paste Almond Flavour'
		page.find('div.floatingFooter') #/<aisle></category>/<subcategory>/<product> - clicked 'Cake paste almond flavour'
		
	end
	
	it "requires a member to log in to view a tobacco flagged category and product list" do

		tobaccoURLs.each do |url|
			Capybara.ignore_hidden_elements = false
			visit url
			#puts url
			find('div.verify-age-login').should be_visible
			find('div.verify-age-my-profile').should_not be_visible
			find('div.verify-age-invalid-age').should_not be_visible
			find('div.verify-age-valid-age').should_not be_visible
			find('div.verify-age-footer').should be_visible
		end
		
		visit(richmond_url)
		page.should have_content('Shop by category')
		click_link 'Shop by category'
		
		page.should have_content('Tobacco')
		
	end
	
	it "requires a member to have a date of birth to view a tobacco flagged product list" do
		visit(richmond_url+'/logon')
		fill_in('Email address', :with => user_email_no_dob)
		fill_in('Password', :with => password)
		click_button('Log in')
		
		tobaccoURLs.each do |url|
			Capybara.ignore_hidden_elements = false
			visit url
			#puts url
			find('div.verify-age-login').should_not be_visible
			find('div.verify-age-my-profile').should be_visible
			find('div.verify-age-invalid-age').should_not be_visible
			find('div.verify-age-valid-age').should_not be_visible
			find('div.verify-age-footer').should be_visible
		end
	end
	
	it "prevents a member who is too young from viewing tobacco flagged product list" do
		visit(richmond_url+'/logon')
		fill_in('Email address', :with => user_email_too_young)
		fill_in('Password', :with => password)
		click_button('Log in')
		
		tobaccoURLs.each do |url|
			Capybara.ignore_hidden_elements = false
			visit url
			#puts url
			find('div.verify-age-login').should_not be_visible
			find('div.verify-age-my-profile').should_not be_visible
			find('div.verify-age-invalid-age').should be_visible
			find('div.verify-age-valid-age').should_not be_visible
			find('div.verify-age-footer').should be_visible
		end
	end
	
	it "allows an old enough member to view tobacco flagged product list" do
		visit(richmond_url+'/logon')
		fill_in('Email address', :with => user_email_old_enough)
		fill_in('Password', :with => password)
		click_button('Log in')
		
		tobaccoURLs.each do |url|
			Capybara.ignore_hidden_elements = false
			visit url
			#puts url
			find('div.verify-age-login').should_not be_visible
			find('div.verify-age-my-profile').should_not be_visible
			find('div.verify-age-invalid-age').should_not be_visible
			find('div.verify-age-valid-age').should be_visible
			find('div.verify-age-footer').should_not be_visible
			all('.eSpot').length == 2 #needs to be enhanced to watch for tobacco espot name
		end
	end
	
	
end