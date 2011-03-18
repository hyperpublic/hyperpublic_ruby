require 'spec_helper'

describe Hyperpublic::Places do
  context "places" do
    before do
      @auth = Hyperpublic::Auth.new("username", "password")
      @hp_places = Hyperpublic::Places.new(@auth)
    end

    it "should be able to get a place" do
      stub_get(@auth, "places/1", '{"id":1, "name":"hyperpublic"}')
      place = @hp_places.find(1)
      place.id.should == 1
    end

    it "should be able to get a list of place by ids" do
      stub_get(@auth, "places?ids[]=1&ids[]=2", '[{"id":1},{"id":2}]')
      places = @hp_places.find(:ids=>[1,2])
      places.count.should == 2
    end

    it "should be able to get a list of places by tags" do
      stub_get(@auth, "places?tags[]=tag1&tags[]=tag2", '[{"id":1},{"id":2}]')
      places = @hp_places.find(:tags=>["tag1", "tag2"])
      places.count.should == 2
    end

    it "should be able to get a list of places by location" do
      stub_get(@auth, "places?location[address][zipcode]=10012", '[{"id":1}, {"id":2}]')
      places = @hp_places.find(:location => {:address => {:zipcode => 10012}})
      places.count.should == 2
    end

    it "should be able to get a list of places by source and source ids" do
      stub_get(@auth, "places/search_by_source?source=Simplegeo&source_ids[]=id1&source_ids[]=id2", '[{"id":1}, {"id":2}]')
      places = @hp_places.by_source("Simplegeo", ["id1", "id2"])
      places.count.should == 2
    end

    it "should be able create a place" do
      stub_post(@auth, "places?", '{"user_id":1, "name":"hyperpublic"}')
      place = @hp_places.create(1, {:name => "hyperpublic"})
      place.name.should == "hyperpublic"
    end

    it "should be able to get a list of locations of a place" do
      stub_get(@auth, "places/1/locations",
        '[{"name":"loc1"}, {"name":"loc2"}]')
      locations = @hp_places.locations(1)
      locations.count.should == 2
    end

    it "should be able to get a new address for a place" do
      stub_get(@auth, "places/1/addresses",
        '[{"name":"add1"}, {"name":"add2"}]')
      addresses = @hp_places.addresses(1)
      addresses.count.should == 2
    end

    it "should be able to get a new zip for a place" do
      stub_get(@auth, "places/1/zipcodes",
        '[{"name":"zip1"}, {"name":"zip2"}]')
      zipcodes = @hp_places.zipcodes(1)
      zipcodes.count.should == 2
    end

    it "should be able to get a new neighborhood for a place" do
      stub_get(@auth, "places/1/neighborhoods",
        '[{"name":"add1"}, {"name":"add2"}]')
      neighborhoods = @hp_places.neighborhoods(1)
      neighborhoods.count.should == 2
    end

    it "should be able to get a new pindrop for a place" do
      stub_get(@auth, "places/1/pindrops",
        '[{"name":"add1"}, {"name":"add2"}]')
      pindrops = @hp_places.pindrops(1)
      pindrops.count.should == 2
    end

    it "should be able to add a new address for a place" do
      stub_post(@auth, "places/1/addresses?", '{"line1":"235 e. 13th st"}')
      addr = @hp_places.address_create(1, {"line1" => "235 . 13th st"})
      addr.count.should == 1
    end

    it "should be able to add a new zipcode for a place" do
      stub_post(@auth, "places/1/zipcodes?", '{"zipcode":"10012"}')
      addr = @hp_places.zipcode_create(1, {"zipcode" => "10012"})
      addr.count.should == 1
    end

    it "should be able to add a new neighborhood for a place" do
      stub_post(@auth, "places/1/neighborhoods?", '{"name":"East Village"}')
      addr = @hp_places.neighborhood_create(1, {"name" => "East Village"})
      addr.count.should == 1
    end

    it "should be able to add a new pindrop for a place" do
      stub_post(@auth, "places/1/pindrops?", '{"lat":"40", "lon":"-73"}')
      addr = @hp_places.pindrop_create(1, {"lat" => "40", "lon" => "-73"})
      addr["lat"].should == "40"
      addr["lon"].should == "-73"
    end

    it "should be able to get a list of tags " do
      stub_get(@auth, "places/1/tags",
        '[{"name": "tag1"}, {"name": "tag2"}]')
      tags = @hp_places.tags(1)
      tags.count.should == 2
    end

    it "should be able to create new tags" do
      stub_post(@auth, "places/1/tags?", '[{"name":"tag1"}, {"name":"tag2"}]')
      tags = @hp_places.tags_create(1, ["tag1", "tag2"])
      tags.count.should == 2
    end

    it "should be able to update tags" do
      stub_put(@auth, "places/1/tags?", '[{"name":"tag1"}, {"name":"tag2"}]')
      tags = @hp_places.tags_update(1, ["tag1", "tag2"])
      tags.count.should == 2
    end

    it "should be able to update a place" do
      stub_put(@auth, "places/1?", '{"name":"new hyperpublic"}')
      place = @hp_places.update(1, {:name => "new hyperpublic"})
      place.name.should == "new hyperpublic"
    end

    it "should be able to delete a place" do
      stub_delete(@auth, "places/1", '{"id":1}')
      place = @hp_places.destroy(1)
      place.id.should == 1
    end

  end
end
