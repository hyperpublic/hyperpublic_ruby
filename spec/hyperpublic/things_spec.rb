require 'spec_helper'

describe Hyperpublic::Things do
  context "things" do
    before do
      @auth = Hyperpublic::OAuth.new("client_id", "client_secret")
      @hp_things = Hyperpublic::Things.new(@auth)
    end

    it "should be able to get a thing" do
      stub_get(@auth, "things/1?", 
        '{"id":"1", "label":"a thing"}')
      thing = @hp_things.find("1")
      thing.id.should == "1"
    end

    it "should be able to get a list of things by ids" do
      stub_get(@auth, "things?ids[0]=1&ids[1]=2",
        '[{"id":1},{"id":2}]')
      things = @hp_things.find({:ids => [1,2]})
      things.count.should == 2
    end

    it "should be able to get a list of things by tags" do
      stub_get(@auth, "things?tags[0]=tag1&tags[1]=tag2", 
        '[{"id":1}, {"id":2}]')
      things = @hp_things.find({:tags => ["tag1", "tag2"]})
      things.count.should == 2
    end

    it "should be able to get a list of things by location" do
      stub_get(@auth, "things?location=10012", 
        '[{"id":1}, {"id":2}]')
      things = @hp_things.find({:location => 10012})
      things.count.should == 2
    end

    it "should be able to create a thing" do
      stub_post(@auth, "things?", '{"user_id":1, "title":"my fave"}')
      person = @hp_things.create({:title=>"my fave", :image_url => "www.hyperpublic.com/image/2832.jpg"})
      person.title.should == "my fave"
    end

  end
end
