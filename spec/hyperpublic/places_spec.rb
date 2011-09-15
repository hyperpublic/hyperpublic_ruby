require 'spec_helper'

describe Hyperpublic::Places do
  context "places" do
    before do
      @auth = Hyperpublic::OAuth.new("username", "password")
      @hp_places = Hyperpublic::Places.new(@auth)
    end

    it "should be able to get a place" do
      stub_get(@auth, "places/1?", '{"id":"1", "name":"hyperpublic"}')
      place = @hp_places.find("1")
      place.id.should == "1"
    end

    it "should be able to get a list of place by ids" do
      stub_get(@auth, "places?ids[0]=1&ids[1]=2", '[{"id":1},{"id":2}]')
      places = @hp_places.find(:ids=>[1,2])
      places.count.should == 2
    end

    it "should be able to get a list of places by tags" do
      stub_get(@auth, "places?tags[0]=tag1&tags[1]=tag2", '[{"id":1},{"id":2}]')
      places = @hp_places.find(:tags=>["tag1", "tag2"])
      places.count.should == 2
    end

    it "should be able to get a list of places by location" do
      stub_get(@auth, "places?location=10012", '[{"id":1}, {"id":2}]')
      places = @hp_places.find(:location => 10012)
      places.count.should == 2
    end

    it "should be able create a place" do
      stub_post(@auth, "places?", '{"user_id":1, "name":"hyperpublic"}')
      place = @hp_places.create({:user_id => 1, :name => "hyperpublic"})
      place.name.should == "hyperpublic"
    end

  end
end
