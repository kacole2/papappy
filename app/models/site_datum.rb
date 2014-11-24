class SiteDatum < ActiveRecord::Base

	def self.scrape
		pappysite = SiteDatum.find(1)
	  	
	    mechanize = Mechanize.new
	    page = mechanize.get('http://www.finewineandgoodspirits.com/webapp/wcs/stores/servlet/SpiritsCatalogSearchResultView?tabSel=1&sortBy=Name&sortDir=ASC&storeId=10051&catalogId=10051&langId=-1&parent_category_rn=Spirits&newsearchlist=no&resetValue=0&searchType=Spirits&minSize=&maxSize=&promotions=&rating=&vintage=&specificType=&price=0&maxPrice=0&varitalCatIf=&region=&country=&varietal=&listSize=45&searchKey=&pageNum=1&totPages=1&level0=Spirits&level1=S_Bourbon&level2=&level3=&keyWordNew=false&VId=&TId=&CId=&RId=&PRc=&FPId=&TRId=&ProId=&isKeySearch=&SearchKeyWord=Name+or+Code')
	    
	    inventory = page.at('.tabSelected_blue').text.strip.tr('AvailableOnline)(','').to_i
	    
	    puts "the saved inventory is" + pappysite.inventory

	    pappyArray = ['Winkle', 'Pappy', 'Van']

	    pappy = pappyArray.any? { |keyword| page.body.include? keyword }

	      if inventory == pappysite.inventory
	        puts "No Changes"
	        pappysite.inventory = inventory
	        pappysite.save
	      else
	        pappysite.inventory = inventory
	        pappysite.save
	        puts "There's a change! There are now " + pappysite.inventory + " items listed"

	        # Override the default "from" address with config/initializers/sms-easy.rb
	        SMSEasy::Client.config['from_address'] = "PAPappy"

	        # Create the client
	        easy = SMSEasy::Client.new

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

	        # Override the default "from" address with config/initializers/sms-easy.rb
	        SMSEasy::Client.config['from_address'] = "PAPappy"

	        # Create the client
	        easy = SMSEasy::Client.new

	        # Deliver a simple mesage.
	        easy.deliver(ENV["KENNY_NUMBER"],"at&t","Pappy Time! Go here -> http://bit.ly/1vxVWJL")
	        #sleep(20.seconds)
	        easy.deliver(ENV["BOBBY_NUMBER"],"at&t","Pappy Time! Go here -> http://bit.ly/1vxVWJL")
	        easy.deliver(ENV["STEVE_NUMBER"],"verizon","Pappy Time! Go here -> http://bit.ly/1vxVWJL")
	        easy.deliver(ENV["SCOTT_NUMBER"],"at&t","Pappy Time! Go here -> http://bit.ly/1vxVWJL")
	      else
	        puts "No Pappy :("
	        pappysite.pappy = false
	        pappysite.save
	      end
	end

end
