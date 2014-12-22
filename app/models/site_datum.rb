class SiteDatum < ActiveRecord::Base

	def self.scrape
	    current_time = Time.now.in_time_zone("Eastern Time (US & Canada)")

	    if current_time.hour.between?(7, 13) 
	    	STDOUT.write "it's " + current_time.strftime("%H:%M").to_s + ", lets scrape!\n"

	    	#Search Page
	    	winklesearch = '://www.finewineandgoodspirits.com/webapp/wcs/stores/servlet/SpiritsCatalogSearchResultView?tabSel=1&sortBy=Name&sortDir=ASC&storeId=10051&catalogId=10051&langId=-1&parent_category_rn=Wines+by+Variety&newsearchlist=yes&resetValue=&searchType=SPIRITS&minSize=&maxSize=&promotions=&rating=&vintage=&specificType=&price=&maxPrice=0&varitalCatIf=&region=&country=&varietal=&listSize=&searchKey=Winkle&pageNum=1&totPages=1&level0=&level1=&level2=&level3=&keyWordNew=true&VId=&TId=&CId=&RId=&PRc=&FPId=&TRId=&ProId=&isKeySearch=Y&SearchKeyWord=Winkle'
	    	
	    	#Select the Active Record entry for saving data
	    	pappysite = SiteDatum.find(1)
	  		
	  		#grab the first possible place where all bourbons online are found
	    	mechanize = Mechanize.new
	    	mechanize.user_agent_alias = 'Mac Safari'
	    	page = mechanize.get('http' + winklesearch)

			#If one of those keywords is found, pappy variable will be true & save the search site to allbourbon
			pappy = ['Winkle', 'Pappy', 'Van'].any? { |keyword| page.parser.css('.s_leftContainer').text.include? keyword }

		    if pappy == true
		        STDOUT.write "There's PAPPY!\n"
		        pappysite.pappy = true
		        pappysite.save

					Thread.new{
						if pappysite.textsent == false
				    		#Save the change in the database before clockwork runs again
				    		pappysite.textsent = true
							pappysite.save

				    		# Override the default "from" address with config/initializers/sms-easy.rb
					        SMSEasy::Client.config['from_address'] = "PA Pappy"
					        # Create the client
					        easy = SMSEasy::Client.new

					        # Deliver the texts to everyone
					        easy.deliver(ENV["KENNY_NUMBER"],"at&t","Pappy Time! Go here -> http://bit.ly/1vxVWJL")
					        easy.deliver(ENV["BOBBY_NUMBER"],"at&t","Pappy Time! Go here -> http://bit.ly/1vxVWJL")
					        easy.deliver(ENV["STEVE_NUMBER"],"verizon","Pappy Time! Go here -> http://bit.ly/1vxVWJL")
					        easy.deliver(ENV["SCOTT_NUMBER"],"at&t","Pappy Time! Go here -> http://bit.ly/1vxVWJL")
					        easy.deliver(ENV["STEVE2_NUMBER"],"at&t","Pappy Time! Go here -> http://bit.ly/1vxVWJL")
					        easy.deliver(ENV["JASON_NUMBER"],"at&t","Pappy Time! Go here -> http://bit.ly/1vxVWJL")
					        easy.deliver(ENV["JASON2_NUMBER"],"verizon","Pappy Time! Go here -> http://bit.ly/1vxVWJL")
						end
					}

		        	if pappysite.ordersubmitted == false
		        		#Save the changes before the clockwork process starts over again.
		        		pappysite.ordersubmitted = true
						pappysite.save

			        	#Start the automated ordering process
			        	def self.order_liquor_login_addtocart(mechanize, userlogin, userpassword, winklesearch)
			        		i = 0
			        		begin
					        	#Go to the login page and submit the login form
				    			login_page = mechanize.get('https://www.finewineandgoodspirits.com/webapp/wcs/stores/servlet/LogonForm?langId=-1&storeId=10051&catalogId=null')
				    			login_form = login_page.form_with(:name => 'Logon')
				    			login_form['logonId'] = userlogin
								login_form['logonPassword'] = userpassword
								login_button = login_form.button_with(:id => 'loginButton')
								loggedin_page = login_form.submit(login_button)

								STDOUT.write "Successfully Logged In as " + userlogin.to_s + " with Mechanize\n"
								
								#Get the list of all the bourbons and search for keywords and add them to the cart
								bourbon_list = mechanize.get('https' + winklesearch)
								bourbon_list_array = bourbon_list.search("//table[@id='productList']")
								bourbon_list_array.each_with_index do |list_item, index|
									if ["10849", "34155", "9532", "30591", "9530", "30744", "Pappy Van Winkle’s", "Van Winkle Special Reserve"].any? { |keyword| list_item.content.include?  keyword }
										bourbon_form = bourbon_list.form_with(:name => 'OrderItemAddForma' + index.to_s)
										bourbon_form.action = "OrderItemAdd"
										results_page = bourbon_form.submit
										STDOUT.write "Item Added to Cart for " + userlogin.to_s + "\n"
									end
								end

								# Logout with Mechanizer so we can login with Watir
								# Comment this out and we save .1 seconds!
								#logout_link = bourbon_list.link_with(id: 'headerLoginAnchorId')
								#logged_out_page = logout_link.click
							rescue
								i += 1
								order_screwed('order_liquor_login_addtocart', i, userlogin)
								retry
							end
						end

						def self.order_liquor_login_watir(browser, userlogin, userpassword)
							i = 0
							begin
								#Login to the site
								browser.goto "https://www.finewineandgoodspirits.com/webapp/wcs/stores/servlet/LogonForm?langId=-1&storeId=10051&catalogId=null"
								browser.text_field(:name => 'logonId').set userlogin
								browser.text_field(:name => 'logonPassword').set userpassword
								browser.link(:id => 'loginButton').click
								browser.div(:id => "accountInfo").wait_until_present
								STDOUT.write "Successfully Logged In as " + userlogin.to_s + " with Watir\n"
							rescue
								i += 1
								order_screwed('order_liquor_login_watir', i, userlogin)
								retry
							end
						end

						def self.order_liquor_quickcheckOut(browser, userlogin)
							i = 0
							begin
								#Go to the checkout cart and click on "Quick Checkout Option"
								browser.goto "https://www.finewineandgoodspirits.com/webapp/wcs/stores/servlet/OrderItemDisplay?langId=-1&storeId=10051&catalogId=10051&orderId=*"
								Watir::Wait.until { browser.title == "Fine Wine & Good Spirits: Shopping cart" }
								browser.link(:id => 'quickcheckOut').click

								#Submit the Order!!
								Watir::Wait.until { browser.title == "Fine Wine & Good Spirits: Checkout Order Review" }
								STDOUT.write "Successfully hit the Quick Checkout Button as " + userlogin.to_s + "\n"
							rescue
								vintages = ["23 Year Old", "20 Year Old", "15 Year Old", "12 Year Old", "10 Year Old", "13 Year Old"]
								vintagetest = vintages.any? { |vintage| browser.span(:class => 'normalTextDarkRed').text.include? vintage}
									if vintagetest == true
										vintage.each do |vintage|
											if browser.span(:class => 'normalTextDarkRed').text.include? vintage
												clear_item_in_cart(browser, vintage, userlogin)
											end
										end
									else
										i += 1
										order_screwed('order_liquor_quickcheckOut', i, userlogin)
									end
								retry
							end
						end

						def self.order_liquor_submitorder(browser, userlogin, userphone, carrier, textmessage)
							i = 0
							begin
								browser.link(:id => 'submitOrder').click
								Watir::Wait.until { browser.title == "Fine Wine & Good Spirits: Order Confirmation" }
								STDOUT.write "Pappy Order for " + userlogin.to_s + " is submitted!\n"
							rescue
								i += 1
								order_screwed('order_liquor_submitorder', i, userlogin)
								retry
							end
								textmessage.deliver(userphone,carrier,"PA Pappy Order for " + userlogin.to_s + " is submitted!")
						end

						def self.clear_item_in_cart(browser, removeitem, userlogin)
							cart_rows = browser.divs(:class => 'colimn_Description').collect{ |x| x.text}
							cart_rows.each do |row|
								itempresent = row.include? removeitem
								if itempresent == true
									browser.td(:text, row).parent.parent.parent.parent.parent.link(:text, /Remove/).click
									Watir::Wait.until { browser.title == "Fine Wine & Good Spirits: Shopping cart" }
									STDOUT.write "Removed " + removeitem + " from cart for " + userlogin + " \n"
								end
							end
						end

						def self.order_screwed(method, attempt, userlogin)
							if i > 4
								STDOUT.write "Tried " + method.to_s + "for the " + attempt.to_s + " time. Time to kill it for " + userlogin.to_s + " \n"
								exit
							else
								STDOUT.write " " + method.to_s + " messed up! Retrying for the " + attempt.to_s + " again for " + userlogin.to_s + " \n"
							end
						end

						def self.order_liquor(userlogin, userpassword, userphone, carrier, winklesearch)
							Thread.new{
								#To create multithreaded processes, we need a new object for mechanize and Watir
								mechanize = Mechanize.new
		    					mechanize.user_agent_alias = 'Mac Safari'

								#We need Watir to click on JS links :(
								#This will only take a few second. We are running Headless with phantomjs
								Watir.default_timeout = 180
								browser = Watir::Browser.new :phantomjs
								textmessage = SMSEasy::Client.new

								order_liquor_login_addtocart(mechanize, userlogin, userpassword, winklesearch)
								order_liquor_login_watir(browser, userlogin, userpassword)
								order_liquor_quickcheckOut(browser, userlogin)
								order_liquor_submitorder(browser, userlogin, userphone, carrier, textmessage)

								browser.close
							}
						end

						kenny_login_1 = ENV["KENNY_ACCOUNT1_EMAIL"]
						kenny_login_2 = ENV["KENNY_ACCOUNT2_EMAIL"]
						kenny_login_3 = ENV["KENNY_ACCOUNT3_EMAIL"]
						kenny_pw = ENV["KENNY_ACCOUNT1_PW"]
						kenny_phone = ENV["KENNY_NUMBER"]

						
						order_liquor(kenny_login_1, kenny_pw, kenny_phone, "at&t", winklesearch)
						sleep(1)
						order_liquor(kenny_login_2, kenny_pw, kenny_phone, "at&t", winklesearch)
						sleep(1)
						order_liquor(kenny_login_3, kenny_pw, kenny_phone, "at&t", winklesearch)
					end

		    else
		        STDOUT.write "No Pappy :(\n"
		        pappysite.pappy = false
		        pappysite.save
		    end

	    else
	    	STDOUT.write "not running because it's not between 7am and 1pm\n"
	    end
	end
end