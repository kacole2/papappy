require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
#require './config/boot'
#require './config/environment'
require 'clockwork'

include Clockwork

every(20.seconds, 'Searching for Pappy...') { SiteDatum.scrape }