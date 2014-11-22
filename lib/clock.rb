require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require './config/boot'
require './config/environment'
require 'clockwork'
require 'rake/dsl_definition'
include Clockwork

Rails.application.load_tasks

every(30.seconds, 'Searching for Pappy...') { "rake runScrape" }