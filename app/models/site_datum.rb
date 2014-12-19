class SiteDatum < ActiveRecord::Base

	def self.scrape
	    current_time = Time.now.in_time_zone("Eastern Time (US & Canada)")

	    if current_time.hour.between?(0, 23) 
	    	STDOUT.write "it's " + current_time.strftime("%H:%M").to_s + ", lets scrape!\n"

	    	#Two possible places it may show up
	    	allbourbon = '://www.finewineandgoodspirits.com/webapp/wcs/stores/servlet/SpiritsCatalogSearchResultView?tabSel=1&sortBy=Name&sortDir=ASC&storeId=10051&catalogId=10051&langId=-1&parent_category_rn=Spirits&newsearchlist=yes&resetValue=&searchType=SPIRITS&minSize=&maxSize=&promotions=&rating=&vintage=&specificType=&price=&maxPrice=0&varitalCatIf=&region=&country=&varietal=&listSize=45&searchKey=Beam&pageNum=1&totPages=1&level0=&level1=&level2=&level3=&keyWordNew=true&VId=&TId=&CId=&RId=&PRc=&FPId=&TRId=&ProId=&isKeySearch=Y&SearchKeyWord=Beam#'
	    	winklesearch = '://www.finewineandgoodspirits.com/webapp/wcs/stores/servlet/SpiritsCatalogSearchResultView?tabSel=1&sortBy=Name&sortDir=ASC&storeId=10051&catalogId=10051&langId=-1&parent_category_rn=Wines+by+Variety&newsearchlist=yes&resetValue=&searchType=SPIRITS&minSize=&maxSize=&promotions=&rating=&vintage=&specificType=&price=&maxPrice=0&varitalCatIf=&region=&country=&varietal=&listSize=&searchKey=Winkle&pageNum=1&totPages=1&level0=&level1=&level2=&level3=&keyWordNew=true&VId=&TId=&CId=&RId=&PRc=&FPId=&TRId=&ProId=&isKeySearch=Y&SearchKeyWord=Winkle'

	    	#Select the Active Record entry for saving data
	    	pappysite = SiteDatum.find(1)

	    	#We need Watir to click on JS links :(
			#This will only take a few second. We are running Headless with phantomjs
			browser = Watir::Browser.new :phantomjs
			browser.goto('http' + allbourbon)
			browser.div(:class => "s_shadowContainer").wait_until_present
		
	    	#Get the inventory number
			inventory = browser.div(:class => 'tabSelected_blue').text.strip.tr('AvailableOnline)(','').to_i
	    	
	    	#The keywords to be searched on the page
			pappyArray = ['Winkle', 'Pappy', 'Van']

			#If one of those keywords is found, pappy variable will be true & save the search site to allbourbon
			pappy = pappyArray.any? { |keyword| browser.div(:class => 'searchCount').text.include? keyword }

			searchsite = allbourbon
				#If it's not found on the first site, check the page where Winkle is the keyword search and
				#set variables accordingly
				if pappy == false
					#sleep a bit so we aren't scrapping rapidly
					sleep(12)
					browser.goto('http' + winklesearch)
					browser.div(:class => "s_shadowContainer").wait_until_present
					pappy = pappyArray.any? { |keyword| browser.div(:class => 'searchCount').text.include? keyword }
					searchsite = winklesearch
				end

		    if pappy == true
		        STDOUT.write "There's PAPPY!\n"
		        pappysite.pappy = true
		        pappysite.save

		        	if pappysite.ordersubmitted == false
		        		#Save the changes before the clockwork process starts over again.
		        		pappysite.ordersubmitted = true
						pappysite.save

			        	#Start the automated ordering process
			        	def self.order_liquor(browser, userlogin, userpassword, userphone, searchsite)

							#Login to the site
							browser.goto "https://www.finewineandgoodspirits.com/webapp/wcs/stores/servlet/LogonForm?langId=-1&storeId=10051&catalogId=null"
							browser.text_field(:name => 'logonId').set userlogin
							browser.text_field(:name => 'logonPassword').set userpassword

							browser.link(:id => 'loginButton').click
							browser.div(:id => "accountInfo").wait_until_present

							browser.goto 'http' + searchsite
							browser.div(:class => 'search_welcomeBanner').wait_until_present

							#Get the list of all the bourbons and search for keywords and add them to the cart
							bourbon_table = browser.divs(:class => 'textBold').collect{ |x| x.text}
							bourbon_table.each do |table|
								if ['Winkle', 'qouting'].any? { |keyword| table.include? keyword }
									browser.div(:text, table).parent.parent.div(:id => 's_buyNow').click
									STDOUT.write "One added\n"
									browser.div(:class => 'sCartBanner').wait_until_present
									browser.back
									browser.div(:class => 'search_welcomeBanner').wait_until_present
								end
							end

							#Go to the checkout cart and click on "Quick Checkout Option"
							browser.goto "https://www.finewineandgoodspirits.com/webapp/wcs/stores/servlet/OrderItemDisplay?langId=-1&storeId=10051&catalogId=10051&orderId=*"
							Watir::Wait.until { browser.title == "Fine Wine & Good Spirits: Shopping cart" }

							browser.link(:id => 'quickcheckOut').click

							#Submit the Order!!
							Watir::Wait.until { browser.title == "Fine Wine & Good Spirits: Checkout Order Review" }
							#browser.link(:id => 'submitOrder').click

							#Logout for the next person
							#Watir::Wait.until { browser.title == "Fine Wine & Good Spirits: Order Confirmation" }
							browser.link(:id => 'headerLoginAnchorId').click
							browser.close

							STDOUT.write "Pappy Order for " + userlogin.to_s + " is submitted!\n"

							#SMSEasy::Client.config['from_address'] = "PAPappy"
							#ordercomplete_text = SMSEasy::Client.new
							#ordercomplete_text.deliver(userphone,"at&t","Pappy Order for " + userlogin.to_s + " is submitted!")
						end

						kenny_login_1 = ENV["KENNY_ACCOUNT1_EMAIL"]
						kenny_login_2 = ENV["KENNY_ACCOUNT2_EMAIL"]
						kenny_pw = ENV["KENNY_ACCOUNT1_PW"]
						kenny_phone = ENV["KENNY_NUMBER"]

						order_liquor(browser, kenny_login_1, kenny_pw, kenny_phone, searchsite)
						#order_liquor(kenny_login_2, kenny_pw, kenny_phone, searchsite)
					end

		    else
		        STDOUT.write "No Pappy :(\n"
		        pappysite.pappy = false
		        pappysite.save
		    end

		    if inventory == pappysite.inventory
		    	STDOUT.write "No Changes\n"
		        pappysite.inventory = inventory
		        pappysite.save
		    else
		        pappysite.inventory = inventory
		        pappysite.save
		        STDOUT.write "There's a change! There are now " + pappysite.inventory.to_s + " items listed\n"
		    end

	    else
	    	STDOUT.write "not running because it's not between 7am and 1pm\n"
	    end

		endtime = Time.now.in_time_zone("Eastern Time (US & Canada)")
		totaltime = endtime - current_time
		puts "it took a total of " + totaltime.to_s + " to complete"
	end

end
