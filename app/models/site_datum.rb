class SiteDatum < ActiveRecord::Base

	def self.scrape
	    current_time = Time.now.in_time_zone("Eastern Time (US & Canada)")

	    if current_time.hour.between?(7, 13) 
	    	puts "it's " + current_time.strftime("%H:%M").to_s + ", lets scrape!"

	    	pappysite = SiteDatum.find(1)
	  	
	    	mechanize = Mechanize.new
	    	page = mechanize.get('http://www.finewineandgoodspirits.com/webapp/wcs/stores/servlet/SpiritsCatalogSearchResultView?tabSel=1&sortBy=Name&sortDir=ASC&storeId=10051&catalogId=10051&langId=-1&parent_category_rn=Spirits&newsearchlist=no&resetValue=0&searchType=Spirits&minSize=&maxSize=&promotions=&rating=&vintage=&specificType=&price=0&maxPrice=0&varitalCatIf=&region=&country=&varietal=&listSize=45&searchKey=&pageNum=1&totPages=1&level0=Spirits&level1=S_Bourbon&level2=&level3=&keyWordNew=false&VId=&TId=&CId=&RId=&PRc=&FPId=&TRId=&ProId=&isKeySearch=&SearchKeyWord=Name+or+Code')
			inventory = page.at('.tabSelected_blue').text.strip.tr('AvailableOnline)(','').to_i
	    
			pappyArray = ['Winkle', 'Pappy', 'Van']
			pappy = pappyArray.any? { |keyword| page.body.include? keyword }

		    if pappy == true
		        puts "There's PAPPY!"
		   
		        	if pappysite.textsent == false
		        		#Save the change in the database before clockwork runs again
		        		pappysite.textsent = true
						pappysite.save

		        		# Override the default "from" address with config/initializers/sms-easy.rb
				        SMSEasy::Client.config['from_address'] = "PAPappy"
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

		        	if pappysite.ordersubmitted == false
		        		#Save the changes before the clockwork process starts over again.
		        		pappysite.ordersubmitted = true
						pappysite.save

			        	#Start the automated ordering process
			        	def self.order_liquor(userlogin, userpassword, userphone)

			        		#Use Mechanize to quickly scrape and put items in the cart.
			        		#If this was done with Watir it would have to perform a "back" function
			        		#because it's an actual headless browser
				        	agent1 = Mechanize.new
				        	agent1.user_agent_alias = 'Mac Safari'

				        	#Go to the login page and submit the login form
			    			login_page = agent1.get('https://www.finewineandgoodspirits.com/webapp/wcs/stores/servlet/LogonForm?langId=-1&storeId=10051&catalogId=null')
			    			login_form = login_page.form_with(:name => 'Logon')
			    			login_form['logonId'] = userlogin
							login_form['logonPassword'] = userpassword
							login_button = login_form.button_with(:id => 'loginButton')
							loggedin_page = login_form.submit(login_button)
							
							#Get the list of all the bourbons and search for keywords and add them to the cart
							bourbon_list = agent1.get('https://www.finewineandgoodspirits.com/webapp/wcs/stores/servlet/SpiritsCatalogSearchResultView?tabSel=1&sortBy=Name&sortDir=ASC&storeId=10051&catalogId=10051&langId=-1&parent_category_rn=Spirits&newsearchlist=no&resetValue=0&searchType=Spirits&minSize=&maxSize=&promotions=&rating=&vintage=&specificType=&price=0&maxPrice=0&varitalCatIf=&region=&country=&varietal=&listSize=45&searchKey=&pageNum=1&totPages=1&level0=Spirits&level1=S_Bourbon&level2=&level3=&keyWordNew=false&VId=&TId=&CId=&RId=&PRc=&FPId=&TRId=&ProId=&isKeySearch=&SearchKeyWord=Name+or+Code')
							bourbon_list_array = bourbon_list.search("//table[@id='productList']")
							bourbon_list_array.each_with_index do |list_item, index|
								if list_item.content.include? "10849"
									bourbon_form = bourbon_list.form_with(:name => 'OrderItemAddForma' + index.to_s)
									bourbon_form.action = "OrderItemAdd"
									results_page = bourbon_form.submit
								elsif list_item.content.include? "34155"
									bourbon_form = bourbon_list.form_with(:name => 'OrderItemAddForma' + index.to_s)
									bourbon_form.action = "OrderItemAdd"
									results_page = bourbon_form.submit
								elsif list_item.content.include? "9532"
									bourbon_form = bourbon_list.form_with(:name => 'OrderItemAddForma' + index.to_s)
									bourbon_form.action = "OrderItemAdd"
									results_page = bourbon_form.submit
								elsif list_item.content.include? "30591"
									bourbon_form = bourbon_list.form_with(:name => 'OrderItemAddForma' + index.to_s)
									bourbon_form.action = "OrderItemAdd"
									results_page = bourbon_form.submit
								elsif list_item.content.include? "9530"
									bourbon_form = bourbon_list.form_with(:name => 'OrderItemAddForma' + index.to_s)
									bourbon_form.action = "OrderItemAdd"
									results_page = bourbon_form.submit
								elsif list_item.content.include? "Pappy Van Winkle’s"
									bourbon_form = bourbon_list.form_with(:name => 'OrderItemAddForma' + index.to_s)
									bourbon_form.action = "OrderItemAdd"
									results_page = bourbon_form.submit
								elsif list_item.content.include? "Van Winkle Special Reserve"
									bourbon_form = bourbon_list.form_with(:name => 'OrderItemAddForma' + index.to_s)
									bourbon_form.action = "OrderItemAdd"
									results_page = bourbon_form.submit
								end
							end

							#Logout with Mechanizer so we can login with Watir
							logout_link = bourbon_list.link_with(id: 'headerLoginAnchorId')
							logged_out_page = logout_link.click

							#We need Watir to click on JS links :(
							#This will only take a few second. We are running Headless with phantomjs
							browser = Watir::Browser.new :phantomjs

							#Login to the site
							browser.goto "https://www.finewineandgoodspirits.com/webapp/wcs/stores/servlet/LogonForm?langId=-1&storeId=10051&catalogId=null"
							browser.text_field(:name => 'logonId').set userlogin
							browser.text_field(:name => 'logonPassword').set userpassword
							browser.link(:id => 'loginButton').click
							browser.div(:id => "accountInfo").wait_until_present

							#Go to the checkout cart and click on "Quick Checkout Option"
							browser.goto "https://www.finewineandgoodspirits.com/webapp/wcs/stores/servlet/OrderItemDisplay?langId=-1&storeId=10051&catalogId=10051&orderId=*"
							Watir::Wait.until { browser.title == "Fine Wine & Good Spirits: Shopping cart" }
							browser.link(:id => 'quickcheckOut').click

							#Submit the Order!!
							Watir::Wait.until { browser.title == "Fine Wine & Good Spirits: Checkout Order Review" }
							browser.link(:id => 'submitOrder').click

							#Logout for the next person
							Watir::Wait.until { browser.title == "Fine Wine & Good Spirits: Order Confirmation" }
							browser.link(:id => 'headerLoginAnchorId').click

							puts "Pappy Order for " + userlogin.to_s + " is submitted!"

							SMSEasy::Client.config['from_address'] = "PAPappy"
							ordercomplete_text = SMSEasy::Client.new
							ordercomplete_text.deliver(userphone,"at&t","Pappy Order for " + userlogin.to_s + " is submitted!")
						end

						kenny_login_1 = ENV["KENNY_ACCOUNT1_EMAIL"]
						kenny_login_2 = ENV["KENNY_ACCOUNT2_EMAIL"]
						kenny_pw = ENV["KENNY_ACCOUNT1_PW"]
						kenny_phone = ENV["KENNY_NUMBER"]

						order_liquor(kenny_login_1, kenny_pw, kenny_phone)
						order_liquor(kenny_login_2, kenny_pw, kenny_phone)
					end

				pappysite.pappy = true
		        pappysite.save

		    else
		        puts "No Pappy :("
		        pappysite.pappy = false
		        pappysite.save
		    end

		    if inventory == pappysite.inventory
		    	puts "No Changes"
		        pappysite.inventory = inventory
		        pappysite.save
		    else
		        pappysite.inventory = inventory
		        pappysite.save
		        puts "There's a change! There are now " + pappysite.inventory.to_s + " items listed"
		    end

	    else
	    	puts "not running because it's not between 7am and 1pm"
	    end

	end

end
