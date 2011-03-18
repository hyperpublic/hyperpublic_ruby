require 'spec_helper'

describe Hyperpublic::People do
  context "base" do
    before do
      @auth = Hyperpublic::Auth.new("username", "password")
      @hp_people = Hyperpublic::People.new(@auth)
    end

    it "should be able to get person" do
      stub_get(@auth, "people/1",
        '{"all_tags":[],"location_children":[],"id":1,
          "image":{"src_thumb":"http://some_url",
          "id":1,"src_large":"http://some_url"}}')
      person = @hp_people.find(1)
      person.id.should == 1
    end

    it "should be able to get a list of people by ids" do
      stub_get(@auth, "people?ids[]=1&ids[]=2", 
        '[{"id":1}, {"id":2}]')
      people = @hp_people.find({:ids => [1, 2]})
      people.count.should == 2
    end

    it "should be able to get a list of people by tags" do
      stub_get(@auth, "people?tags[]=tag1&tags[]=tag2", 
        '[{"id":1}, {"id":2}]')
      people = @hp_people.find({:tags => ["tag1", "tag2"]})
      people.count.should == 2
    end

    it "should be able to get a list of people by location" do
      stub_get(@auth, "people?location[address][zipcode]=10012", 
        '[{"id":1}, {"id":2}]')
      people = @hp_people.find({:location => {:address => {:zipcode => 10012}}})
      people.count.should == 2
    end

    #TODO: finish this
    it "should be able to create a user" do
      stub_post(@auth, "people?", '{"email":"etang@hyperpublic.com"}')
      person = @hp_people.create("etang@hyperpublic.com", {:image_url => "www.hyperpublic.com/image/2832.jpg"})
      person.email.should == "etang@hyperpublic.com"
    end

    #TODO: finish this
    it "should be able to update a user" do
      stub_put(@auth, "people/1?", '{"email":"etang@hyperpublic.com"}')
      person = @hp_people.update(1, {:email=>"etang@hyperpublic.com"})
      person.email.should == "etang@hyperpublic.com"
    end

    it "should be able to delete a user" do
      stub_delete(@auth, "people/1", '{"id":1}')
      person = @hp_people.destroy(1)
      person.id.should == 1
    end

    it "should be able to get a list of locations of a user" do
      stub_get(@auth, "people/1/locations",
        '[{"name":"loc1"}, {"name":"loc2"}]')
      locations = @hp_people.locations(1)
      locations.count.should == 2
    end

    it "should be able to get a new address for a user" do
      stub_get(@auth, "people/1/addresses",
        '[{"name":"add1"}, {"name":"add2"}]')
      addresses = @hp_people.addresses(1)
      addresses.count.should == 2
    end

    it "should be able to get a new zip for a user" do
      stub_get(@auth, "people/1/zipcodes",
        '[{"name":"zip1"}, {"name":"zip2"}]')
      zipcodes = @hp_people.zipcodes(1)
      zipcodes.count.should == 2
    end

    it "should be able to get a new neighborhood for a user" do
      stub_get(@auth, "people/1/neighborhoods",
        '[{"name":"add1"}, {"name":"add2"}]')
      neighborhoods = @hp_people.neighborhoods(1)
      neighborhoods.count.should == 2
    end

    it "should be able to get a new pindrop for a user" do
      stub_get(@auth, "people/1/pindrops",
        '[{"name":"add1"}, {"name":"add2"}]')
      pindrops = @hp_people.pindrops(1)
      pindrops.count.should == 2
    end

    it "should be able to add a new address for a user" do
      stub_post(@auth, "people/1/addresses?", '{"line1":"235 e. 13th st"}')
      addr = @hp_people.address_create(1, {"line1" => "235 . 13th st"})
      addr.count.should == 1
    end

    it "should be able to add a new zipcode for a user" do
      stub_post(@auth, "people/1/zipcodes?", '{"zipcode":"10012"}')
      addr = @hp_people.zipcode_create(1, {"zipcode" => "10012"})
      addr.count.should == 1
    end

    it "should be able to add a new neighborhood for a user" do
      stub_post(@auth, "people/1/neighborhoods?", '{"name":"East Village"}')
      addr = @hp_people.neighborhood_create(1, {"name" => "East Village"})
      addr.count.should == 1
    end

    it "should be able to add a new pindrop for a user" do
      stub_post(@auth, "people/1/pindrops?", '{"lat":"40", "lon":"-73"}')
      addr = @hp_people.pindrop_create(1, {"lat" => "40", "lon" => "-73"})
      addr["lat"].should == "40"
      addr["lon"].should == "-73"
    end

    it "should be able to get a list of tags " do
      stub_get(@auth, "people/1/tags",
        '[{"name": "tag1"}, {"name": "tag2"}]')
      tags = @hp_people.tags(1)
      tags.count.should == 2
    end

    it "should be able to create new tags" do
      stub_post(@auth, "people/1/tags?", '[{"name":"tag1"}, {"name":"tag2"}]')
      tags = @hp_people.tags_create(1, ["tag1", "tag2"])
      tags.count.should == 2
    end

    it "should be able to update tags" do
      stub_put(@auth, "people/1/tags?", '[{"name":"tag1"}, {"name":"tag2"}]')
      tags = @hp_people.tags_update(1, ["tag1", "tag2"])
      tags.count.should == 2
    end

    it "should be able to suggest a tag" do
      stub_post(@auth, "people/2/tags/suggest?", '{"suggestor_id":2, "user_id":1, "label":"cool"}')
      tag = @hp_people.tag_suggest(2, 1, "cool")
      tag.label.should == "cool"
    end

    it "should be able to moderate a suggested tag" do
      stub_put(@auth, "people/1/tags/moderate?", '{"suggestor_id":2, "user_id":1, "label":"cool"}')
      tag = @hp_people.tag_moderate(1, 1, "accept")
      tag.label.should == "cool"
    end

    it "should be able to recognize a user" do
      stub_post(@auth, "people/recognize?",
        '{"recognizer_id":1,
          "recognizee_id":2,
          "context":"hola"}')
      rec = @hp_people.recognize(1, 2, "hola")
      rec.recognizer_id.should == 1
    end
  end
end
