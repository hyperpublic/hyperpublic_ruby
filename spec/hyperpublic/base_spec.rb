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

  end
end
