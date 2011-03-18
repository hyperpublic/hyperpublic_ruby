require 'spec_helper'

describe Hyperpublic::Things do
  context "things" do
    before do
      @auth = Hyperpublic::Auth.new("username", "password")
      @hp_things = Hyperpublic::Things.new(@auth)
    end

    it "should be able to get a thing" do
      stub_get(@auth, "things/1", 
        '{"id":1, "label":"a thing"}')
      thing = @hp_things.find(1)
      thing.id.should == 1
    end

    it "should be able to get a list of things by ids" do
      stub_get(@auth, "things?ids[]=1&ids[]=2",
        '[{"id":1},{"id":2}]')
      things = @hp_things.find({:ids => [1,2]})
      things.count.should == 2
    end

    it "should be able to get a list of things by tags" do
      stub_get(@auth, "things?tags[]=tag1&tags[]=tag2", 
        '[{"id":1}, {"id":2}]')
      things = @hp_things.find({:tags => ["tag1", "tag2"]})
      things.count.should == 2
    end

    it "should be able to get a list of things by location" do
      stub_get(@auth, "things?location[address][zipcode]=10012", 
        '[{"id":1}, {"id":2}]')
      things = @hp_things.find({:location => {:address => {:zipcode => 10012}}})
      things.count.should == 2
    end

    it "should be able to create a thing" do
      stub_post(@auth, "things?", '{"user_id":1, "title":"my fave"}')
      person = @hp_things.create(1, {:title=>"my fave", :image_url => "www.hyperpublic.com/image/2832.jpg"})
      person.title.should == "my fave"
    end

    it "should be able to get a list of locations of a thing" do
      stub_get(@auth, "things/1/locations",
        '[{"name":"loc1"}, {"name":"loc2"}]')
      locations = @hp_things.locations(1)
      locations.count.should == 2
    end

    it "should be able to get a new address for a thing" do
      stub_get(@auth, "things/1/addresses",
        '[{"name":"add1"}, {"name":"add2"}]')
      addresses = @hp_things.addresses(1)
      addresses.count.should == 2
    end

    it "should be able to get a new zip for a thing" do
      stub_get(@auth, "things/1/zipcodes",
        '[{"name":"zip1"}, {"name":"zip2"}]')
      zipcodes = @hp_things.zipcodes(1)
      zipcodes.count.should == 2
    end

    it "should be able to get a new neighborhood for a thing" do
      stub_get(@auth, "things/1/neighborhoods",
        '[{"name":"add1"}, {"name":"add2"}]')
      neighborhoods = @hp_things.neighborhoods(1)
      neighborhoods.count.should == 2
    end

    it "should be able to get a new pindrop for a thing" do
      stub_get(@auth, "things/1/pindrops",
        '[{"name":"add1"}, {"name":"add2"}]')
      pindrops = @hp_things.pindrops(1)
      pindrops.count.should == 2
    end

    it "should be able to add a new address for a thing" do
      stub_post(@auth, "things/1/addresses?", '{"line1":"235 e. 13th st"}')
      addr = @hp_things.address_create(1, {"line1" => "235 . 13th st"})
      addr.count.should == 1
    end

    it "should be able to add a new zipcode for a thing" do
      stub_post(@auth, "things/1/zipcodes?", '{"zipcode":"10012"}')
      addr = @hp_things.zipcode_create(1, {"zipcode" => "10012"})
      addr.count.should == 1
    end

    it "should be able to add a new neighborhood for a thing" do
      stub_post(@auth, "things/1/neighborhoods?", '{"name":"East Village"}')
      addr = @hp_things.neighborhood_create(1, {"name" => "East Village"})
      addr.count.should == 1
    end

    it "should be able to add a new pindrop for a thing" do
      stub_post(@auth, "things/1/pindrops?", '{"lat":"40", "lon":"-73"}')
      addr = @hp_things.pindrop_create(1, {"lat" => "40", "lon" => "-73"})
      addr["lat"].should == "40"
      addr["lon"].should == "-73"
    end

    it "should be able to get a list of tags " do
      stub_get(@auth, "things/1/tags",
        '[{"name": "tag1"}, {"name": "tag2"}]')
      tags = @hp_things.tags(1)
      tags.count.should == 2
    end

    it "should be able to create new tags" do
      stub_post(@auth, "things/1/tags?", '[{"name":"tag1"}, {"name":"tag2"}]')
      tags = @hp_things.tags_create(1, ["tag1", "tag2"])
      tags.count.should == 2
    end

    it "should be able to update tags" do
      stub_put(@auth, "things/1/tags?", '[{"name":"tag1"}, {"name":"tag2"}]')
      tags = @hp_things.tags_update(1, ["tag1", "tag2"])
      tags.count.should == 2
    end

    it "should be able to update a thing" do
      stub_put(@auth, "things/1?", '{"title":"my new fave"}')
      thing = @hp_things.update(1, {:title => "my new fave"})
      thing.title.should == "my new fave"
    end

    it "should be able to delete a thing" do
      stub_delete(@auth, "things/1", '{"id":1}')
      thing = @hp_things.destroy(1)
      thing.id.should == 1
    end

    it "should be able to contact a thing owner" do
      stub_post(@auth, "things/contact_owner?",
        '{"thing_id":1, "from_email":"etang@hyperpublic.com","body":"i want this"}')
      message = @hp_things.contact_owner(1, "etang@hyperpublic.com", "i want this")
      message.thing_id.should == 1
      message.from_email.should == "etang@hyperpublic.com"
    end

  end
end
