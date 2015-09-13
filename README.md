# Ruby Forensics
A Ruby 2.2.3 project, which uses Sinatra, Bootstrap, Google Maps API and RSpec for testing.  
To run the RSpec tests, run rspec spec/location_spec.rb from the command line.  
The system reads from a remote API, which returns a list of directions each of which can be left, right or forward. Given that the start direction is North and the start coordinates are (0,0), the system returns the destination coordinates.  
The system can also return an array of lat/lng pairs so the route can be drawn onto a map.