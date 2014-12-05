class SiteDatum < ActiveRecord::Base

	def self.scrape
		pappysite = SiteDatum.find(1)
	  	
	    mechanize = Mechanize.new
	    page = mechanize.get('http://www.finewineandgoodspirits.com/webapp/wcs/stores/servlet/SpiritsCatalogSearchResultView?tabSel=1&sortBy=Name&sortDir=ASC&storeId=10051&catalogId=10051&langId=-1&parent_category_rn=Spirits&newsearchlist=no&resetValue=0&searchType=Spirits&minSize=&maxSize=&promotions=&rating=&vintage=&specificType=&price=0&maxPrice=0&varitalCatIf=&region=&country=&varietal=&listSize=45&searchKey=&pageNum=1&totPages=1&level0=Spirits&level1=S_Bourbon&level2=&level3=&keyWordNew=false&VId=&TId=&CId=&RId=&PRc=&FPId=&TRId=&ProId=&isKeySearch=&SearchKeyWord=Name+or+Code')
	    
	    inventory = page.at('.tabSelected_blue').text.strip.tr('AvailableOnline)(','').to_i
	    
	    pappyArray = ['Winkle', 'Pappy', 'Van']

	    pappy = pappyArray.any? { |keyword| page.body.include? keyword }

	    current_time = Time.now.in_time_zone("Eastern Time (US & Canada)")

	    if current_time.hour.between?(7, 13) 
	    	puts "it's " + current_time.strftime("%H:%M").to_s + ", lets scrape!"
	    	
		    if inventory == pappysite.inventory
		    	puts "No Changes"
		        pappysite.inventory = inventory
		        pappysite.save
		    else
		        pappysite.inventory = inventory
		        pappysite.save
		        puts "There's a change! There are now " + pappysite.inventory.to_s + " items listed"

		        #SMSEasy::Client.config['from_address'] = "PAPappy"
		        #easy = SMSEasy::Client.new
		        # Deliver a simple message.
		        #easy.deliver(ENV["KENNY_NUMBER"],"at&t","Inventory Change! There are now " + inventory.to_s + " items available. http://bit.ly/1vxVWJL")
		        #sleep(20.seconds)
		        #easy.deliver(ENV["BOBBY_NUMBER"],"at&t","Inventory Change! There are now " + inventory.to_s + " items available. http://bit.ly/1vxVWJL")
		        #easy.deliver(ENV["STEVE_NUMBER"],"verizon","Inventory Change! There are now " + inventory.to_s + " items available. http://bit.ly/1vxVWJL")
		        #easy.deliver(ENV["SCOTT_NUMBER"],"at&t","Inventory Change! There are now " + inventory.to_s + " items available. http://bit.ly/1vxVWJL")
		    end

		    if pappy == true
		        puts "There's PAPPY!"
		        pappysite.pappy = true
		        pappysite.save

		        	if pappysite.textsent == false
		        		# Override the default "from" address with config/initializers/sms-easy.rb
				        SMSEasy::Client.config['from_address'] = "PAPappy"
				        # Create the client
				        easy = SMSEasy::Client.new

				        # Deliver a simple mesage.
				        easy.deliver(ENV["KENNY_NUMBER"],"at&t","Pappy Time! Go here -> http://bit.ly/1vxVWJL")
				        #sleep(29.seconds)
				        easy.deliver(ENV["BOBBY_NUMBER"],"at&t","Pappy Time! Go here -> http://bit.ly/1vxVWJL")
				        easy.deliver(ENV["STEVE_NUMBER"],"verizon","Pappy Time! Go here -> http://bit.ly/1vxVWJL")
				        easy.deliver(ENV["SCOTT_NUMBER"],"at&t","Pappy Time! Go here -> http://bit.ly/1vxVWJL")
				        easy.deliver(ENV["STEVE2_NUMBER"],"at&t","Pappy Time! Go here -> http://bit.ly/1vxVWJL")
				        easy.deliver(ENV["JASON_NUMBER"],"at&t","Pappy Time! Go here -> http://bit.ly/1vxVWJL")
				        easy.deliver(ENV["JASON2_NUMBER"],"verizon","Pappy Time! Go here -> http://bit.ly/1vxVWJL")

				        pappysite.textsent = true
						pappysite.save
					end


		        	if pappysite.ordersubmitted == false
			        	#Start the automated ordering process
			        	def self.order_liquor(userlogin, userpassword, kryptocarturl, userphone)
				        	agent1 = Mechanize.new
				        	agent1.user_agent_alias = 'Mac Safari'
			    			login_page = agent1.get('https://www.finewineandgoodspirits.com/webapp/wcs/stores/servlet/LogonForm?langId=-1&storeId=10051&catalogId=null')
			    			
			    			login_form = login_page.form_with(:name => 'Logon')

			    			login_form['logonId'] = userlogin
							login_form['logonPassword'] = userpassword
							login_button = login_form.button_with(:id => 'loginButton')
							loggedin_page = login_form.submit(login_button)
							
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
								#elsif list_item.content.include? "Booker's Bourbon"
								#	puts "I got added by title"
								#	bourbon_form = bourbon_list.form_with(:name => 'OrderItemAddForma' + index.to_s)
								#	bourbon_form.action = "OrderItemAdd"
								#	results_page = bourbon_form.submit
								#elsif list_item.content.include? "6917"
								#	puts "I got added by code number"
								#	bourbon_form = bourbon_list.form_with(:name => 'OrderItemAddForma' + index.to_s)
								#	bourbon_form.action = "OrderItemAdd"
								#	results_page = bourbon_form.submit
								end
							end

							submit_page = agent1.get(kryptocarturl)

							#submit_form = submit_page.form_with(:name => 'CardInfo')
							#submit_form.action = "Handle_Submit"
							#submit_button = submit_form.button_with(:id => 'submitOrder')

							#order submition
							#done_page = agent1.submit(submit_form, submit_button)
							#puts done_page.body

							logout_link = submit_page.link_with(id: 'headerLoginAnchorId')
							logged_out_page = logout_link.click

							puts "Pappy Order for " + userlogin.to_s + " is submitted!"

							SMSEasy::Client.config['from_address'] = "PAPappy"
							ordercomplete_text = SMSEasy::Client.new
							ordercomplete_text.deliver(userphone,"at&t","Pappy Order for " + userlogin.to_s + " is submitted!")
						end

						kenny_login_1 = ENV["KENNY_ACCOUNT1_EMAIL"]
						kenny_login_2 = ENV["KENNY_ACCOUNT2_EMAIL"]
						kenny_pw = ENV["KENNY_ACCOUNT1_PW"]
						kenny_phone = ENV["KENNY_NUMBER"]
						kenny_krypto_cart_1 = ENV["KENNY_ACCOUNT1_KRYPTOCART"]
						kenny_krypto_cart_2 = ENV["KENNY_ACCOUNT2_KRYPTOCART"]

						order_liquor(kenny_login_1, kenny_pw, kenny_krypto_cart_1, kenny_phone)
						order_liquor(kenny_login_2, kenny_pw, kenny_phone)

						pappysite.ordersubmitted = true
						pappysite.save
					end
					
		    else
		        puts "No Pappy :("
		        pappysite.pappy = false
		        pappysite.save
		    end

	    else
	    	puts "not running because it's not between 7am and 1pm"
	    end
	end

end
