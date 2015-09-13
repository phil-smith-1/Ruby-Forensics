require 'spec_helper'
require './forensics'

RSpec.describe Location do
	#Set up a new location
	before(:all) do
		@location = Location.new
	end

	it "Can turn the compass correctly" do
		#Check the results when turning left and right from each orientation
		expect(@location.turn("north","left")).to eq "west"
		expect(@location.turn("north","right")).to eq "east"
		expect(@location.turn("south","left")).to eq "east"
		expect(@location.turn("south","right")).to eq "west"
		expect(@location.turn("east","left")).to eq "north"
		expect(@location.turn("east","right")).to eq "south"
		expect(@location.turn("west","left")).to eq "south"
		expect(@location.turn("west","right")).to eq "north"
	end

	it "Can return an array of gmap lat/long" do
		#Set up gmap variable for testing
		gmap = @location.get_coordinates("gmap")
		#Check that an array is returned
		expect(gmap.is_a? Array).to be true
		#Check that there is at least one entry in the array
		expect(gmap.length). to be > 0
		#Check that the type of all entries in array is float
		gmap.each do |coordinate|
			expect(coordinate[:lat].is_a? Float).to be true
			expect(coordinate[:lng].is_a? Float).to be true
		end
	end

	it "Can return a Hash containing coordinates for X and Y" do
		#Set up final coordinates variable for testing
		coordinates = @location.get_coordinates("final_coordinates")
		#Check that a hash is returned
		expect(coordinates.is_a? Hash).to be true
		#Check that there are four entries in the Hash
		expect(coordinates.length).to eq 4
		#Check that the X and Y entries are Integers
		expect(coordinates[:x].is_a? Integer).to be true
		expect(coordinates[:y].is_a? Integer).to be true
		#Check that the lat and lng entires are floats
		expect(coordinates[:lat].is_a? Float).to be true
		expect(coordinates[:lng].is_a? Float).to be true
	end
end