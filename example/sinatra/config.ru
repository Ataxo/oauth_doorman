# config.ru
require './sinatra.rb'

# Map applications
run Rack::URLMap.new \
  "/"       => DoormanExampleSinatra.new