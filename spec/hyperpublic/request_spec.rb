require 'spec_helper'

describe Hyperpublic::Request do
  context "new get request" do
    before do
      @client = mock('hyperpublic client')
      @request = Hyperpublic::Request.new(@client, :get, '/people', {:query => {:tags => "tag1"}})
    end

    it "should have a client" do
      @request.client.should == @client
    end

    it "should have method" do
      @request.method == :get
    end

    it "should have path" do
      @request.path.should == "/people"
    end

    it "should have options" do
      @request.options[:query][:tags].should == "tag1"
    end

    it "should have uri" do
      @request.uri.should == "/people?tags=tag1"
    end

    context "performing request for collection" do
      before do
        response = mock('response') do

        end
      end
    end

    #TODO:finish error test cases
    context "error raising" do

    end
  end
end
