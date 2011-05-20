The Hyperpublic Ruby Gem
======================

A Ruby wrapper for the Hyperpublic REST API


Installation
----------------
gem install hyperpublic-ruby


Sample Usage
----------------
    require 'hyperpublic'

    auth = Hyperpublic::OAuth.new("key", "secret")
    places_client = Hyperpublic::Places.new(auth)

    place = places_client.find("4dd53bffe2f2d70816000001")


Documentation
---------------
visit our [developer site](http://developer.hyperpublic.com) for more information.
