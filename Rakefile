# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :scrape do

  desc "Finding Pappy..."
  task :runScrape do
  	pappysite = SiteDatum.find(1)
  	
    mechanize = Mechanize.new
    page = mechanize.get('http://www.finewineandgoodspirits.com/webapp/wcs/stores/servlet/SpiritsCatalogSearchResultView?tabSel=1&sortBy=Name&sortDir=ASC&storeId=10051&catalogId=10051&langId=-1&parent_category_rn=Spirits&newsearchlist=no&resetValue=0&searchType=Spirits&minSize=&maxSize=&promotions=&rating=&vintage=&specificType=&price=0&maxPrice=0&varitalCatIf=&region=&country=&varietal=&listSize=45&searchKey=&pageNum=1&totPages=1&level0=Spirits&level1=S_Bourbon&level2=&level3=&keyWordNew=false&VId=&TId=&CId=&RId=&PRc=&FPId=&TRId=&ProId=&isKeySearch=&SearchKeyWord=Name+or+Code')
    
    inventory = page.at('.tabSelected_blue').text.strip.tr('AvailableOnline)(','').to_i
    pappy = page.body.include?('Winkle')
      if pappysite.inventory == inventory
        puts "No Changes"
      else
        puts "There's a change!"
        pappysite.inventory = inventory
        pappysite.save

        # Override the default "from" address with config/initializers/sms-easy.rb
        SMSEasy::Client.config['from_address'] = "PAPappy"

        # Create the client
        easy = SMSEasy::Client.new

        # Deliver a simple message.
        easy.deliver(ENV["KENNY_NUMBER"],"at&t","There are now " + inventory.to_s + " items available. http://bit.ly/1vxVWJL")
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
      else
        puts "No Pappy :("
        pappysite.pappy = false
        pappysite.save
      end
  end

end
