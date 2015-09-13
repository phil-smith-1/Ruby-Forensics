require 'sinatra/base'
require 'sinatra/contrib'
require 'uri'
require 'httpclient'
require 'json'

class Location
	#Function to trtanslate relativer left/right turns into an absolute compass direction
	def turn(facing, turn)
		if facing == "north"
			turn == "left" ? "west" : "east"
		elsif facing == "east"
			turn == "left" ? "north" : "south"
		elsif facing == "south"
			turn == "left" ? "east" : "west"
		elsif facing == "west"
			turn == "left" ? "south" : "north"
		end
	end

	#Function to return both coordinates and lat/lng depending on the parameter sent. "gmap" returns Array of lat/lng positions to draw the route. "final_coordinates" returns a Hash of the coordinates of the Lair
	def get_coordinates(type)
		uri = URI("http://which-technical-exercise.herokuapp.com/api/pcsmith86@gmail.com/directions")
		#Get data from web service
		http = HTTPClient.new
		response = http.get(uri)
		
		#Check status of http request
		if response.status == 200
			#Parse JSON
			directions = JSON.parse(response.content)
			#directions = JSON.parse("{\"directions\":[\"forward\",\"right\",\"forward\",\"forward\",\"forward\",\"left\",\"forward\",\"forward\",\"left\",\"right\",\"forward\",\"right\",\"forward\",\"forward\",\"right\",\"forward\",\"forward\",\"left\"]}")

			#Check that JSON has parsed correctly
			if directions
				#Set initial values of compass, X and Y coordinates and lat/lng
				compass = "north"
				coordinates = {:x => 0, :y => 0, :lat => 51.522552, :lng => -0.149413}
				gmap = [{:lat => 51.522552, :lng => -0.149413}]
				#Process directions and collect coordinates and lat/lng
				directions["directions"].each do |direction|
					#Process the forward directions, as they will alter the coordinates and lat/lng
					if direction == "forward"
						if compass == "north"
							coordinates[:y] += 1
							coordinates[:lat] += 0.001
						elsif compass == "east"
							coordinates[:x] += 1
							coordinates[:lng] += 0.001
						elsif compass == "south"
							coordinates[:y] -= 1
							coordinates[:lat] -= 0.001
						elsif compass == "west"
							coordinates[:x] -= 1
							coordinates[:lng] -= 0.001
						end
						#Add lat/lng to gmap array
						gmap.push({:lat => coordinates[:lat], :lng => coordinates[:lng]})
					else
						#If the direction is not forward, it muast be left or right. Call the turn function to update the compass variable
						compass = turn(compass, direction)
					end
				end
				if type == "final_coordinates"
					#Return final coordinates
					return coordinates
				elsif type == "gmap"
					#Return lat/lng values to draw Google map polyline
					return gmap
				end
			end
		#If there is a problem with the JSON call, error gracefully by returning the expected data type but empty
		elsif type == "final_coordinates"
			return Hash.new
		elsif type == "gmap"
			return Array.new
		end
	end
end

class ForensicsDisplay < Sinatra::Base
  set :bind, '0.0.0.0'
  register Sinatra::Contrib

  get '/' do
    @location = Location.new
    @final_coordinates = @location.get_coordinates("final_coordinates")
    erb :index
  end
end