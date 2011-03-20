The Hyperpublic Ruby Gem
======================

A Ruby wrapper for the Hyperpublic REST API


Installation
----------------
gem install hyperpublic-ruby


Sample Usage
----------------
    require 'hyperpublic-ruby'

    auth = Hyperpublic::OAuth.new("key", "secret")
    people_client = Hyperpublic::People.new(auth)

    person = people_client.find(4)


Documentation
---------------
visit our [developer site](http://developer.hyperpublic.com) for more information.
