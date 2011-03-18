require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Hyperpublic do
  describe ".user_agent" do
    it "should default User Agent to 'Ruby Hyperpublic Gem'" do
      Hyperpublic.user_agent.should == 'Ruby Hyperpublic Gem'
    end
  end

  context 'when overriding the user agent' do
    describe '.user_agent' do
      it 'should be able to specify the User Agent' do
        Hyperpublic.user_agent = 'My Hyperpublic Gem'
        Hyperpublic.user_agent.should == 'My Hyperpublic Gem'
      end
    end
  end

end
