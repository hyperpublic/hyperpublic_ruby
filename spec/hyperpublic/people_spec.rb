require 'spec_helper'

describe Hyperpublic::People do
  context "base" do
    before do
      @auth = Hyperpublic::OAuth.new("username", "password")
      @hp_people = Hyperpublic::People.new(@auth)
    end

    it "should be able to get person" do
      stub_get(@auth, "people/1?",
        '{"all_tags":[],"locations":[],"id":"1",
          "image":{"src_thumb":"http://some_url",
          "id":1,"src_large":"http://some_url"}}')
      person = @hp_people.find("1")
      person.id.should == "1"
    end

    it "should be able to get a list of people by ids" do
      stub_get(@auth, "people?ids[0]=1&ids[1]=2", 
        '[{"id":1}, {"id":2}]')
      people = @hp_people.find({:ids => [1, 2]})
      people.count.should == 2
    end

    it "should be able to get a list of people by tags" do
      stub_get(@auth, "people?tags[0]=tag1&tags[1]=tag2", 
        '[{"id":1}, {"id":2}]')
      people = @hp_people.find({:tags => ["tag1", "tag2"]})
      people.count.should == 2
    end

    it "should be able to get a list of people by location" do
      stub_get(@auth, "people?location=10012", 
        '[{"id":1}, {"id":2}]')
      people = @hp_people.find({:location  => 10012})
      people.count.should == 2
    end

    #TODO: finish this
    it "should be able to create a user" do
      stub_post(@auth, "people", '{"email":"etang@hyperpublic.com"}')
      person = @hp_people.create({:email => "etang@hyperpublic.com", :image_url => "www.hyperpublic.com/image/2832.jpg"})
      person.email.should == "etang@hyperpublic.com"
    end

  end
end
