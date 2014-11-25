# PAPappy
-------------

This is a rails project that will scrape the PA liquor website for the word "Pappy" "Van" & "Winkle". It will notify you via SMS if that word is found. There is also some disabled code that can notify you on online inventory changes. However, that doesn't work well because the use of load balancers may fire off a flurry of SMS messages.

Things you need to know:

* 2 Components:
  - Web Front End that is dictated by the first id: 1
  - A task worker by 'clockwork' that does a reoccuring scrape every 30 seconds

* The current code is deployed on Cloud Foundry. If you want to deploy on Heroku, it will require the use of a Procfile and using the same command that is in the manifest.yml file

* This requires two containers or two dynos if running on Cloud Foundry or Heroku, respectively. Watch out for $.

* Use the seed.rb file to seed the database for the first time.


More information can be found on [Creating a worker process on kendrickcoleman.com](http://kendrickcoleman.com/index.php/Tech-Blog/creating-a-worker-process-on-cloud-foundry-with-clockwork.html)