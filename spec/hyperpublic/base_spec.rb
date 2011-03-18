require 'spec_helper'

describe Hyperpublic::Base do
  context "base" do
    before do
      @auth = Hyperpublic::Auth.new("username", "password")
      @hyperpublic = Hyperpublic::Base.new(@auth)
    end

    context "initialize" do
      it "should require a client" do
        #@hyperpublic.client.
      end
    end

    it "should delegate get to the client" do
      @auth.should_receive(:get).with("/foo")
      @hyperpublic.get("/foo")
    end

    it "should delegate post to the client" do
      @auth.should_receive(:post).with("/foo", {:bar => "baz"}).and_return(nil)
      @hyperpublic.post("/foo", {:bar => "baz"})
    end

    context "hitting the api" do

      it "should be able to search neighborhoods" do
        stub_get(@auth, "locations/search_neighborhoods?search_string=C&limit=10", '[{"name":"Clinton Hill"}, {"name":"Chelsea"}]')
        nabes = @hyperpublic.search_neighborhoods("C", 10)
        nabes.count.should == 2
      end

      it "should be able to search for tags" do
        stub_get(@auth, "tags/search?search_string=coo&limit=1", '[{"name":"cool"}]')
        tags = @hyperpublic.search_tags("coo", 1)
        tags.count.should == 1
      end

=begin
      it "should be able to upload photos" do
        img_file = mock('File')
        stub_post(@auth, "photos?", '{"id":1, "src_thumb":"www.hyperpublic.com/pic.jpg", "src_large":"www.hyperpublic.com/pic2.jpg"')
        photo = @hyperpublic.photo_create("person", 1, img_file)
        photo.id.should == 1
      end
=end
    end
  end
end
