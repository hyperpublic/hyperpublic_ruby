require 'spec_helper'

describe Hyperpublic::Base do
  context "base" do
    before do
      @auth = Hyperpublic::OAuth.new("username", "password")
      @hyperpublic = Hyperpublic::Base.new(@auth)
    end

    it "should delegate get to the client" do
      @auth.should_receive(:get).with("/foo")
      @hyperpublic.get("/foo")
    end

    it "should delegate post to the client" do
      @auth.should_receive(:post).with("/foo", {:bar => "baz"}).and_return(nil)
      @hyperpublic.post("/foo", {:bar => "baz"})
    end

    it "should not raise an exception on the call to stringify" do
      hash = {:this => "is", :a => "test"}
      lambda {@hyperpublic.send(:stringify, hash)}.should_not raise_exception
    end

  end
end
