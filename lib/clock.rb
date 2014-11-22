require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
#require './config/boot'
#require './config/environment'
require 'clockwork'

include Clockwork

every(30.seconds, 'Queueing interval job') { 'rake scrape:runScrape' }