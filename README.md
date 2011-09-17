#The Hyperpublic Ruby Gem
=========================

A Ruby wrapper for the Hyperpublic REST API


Installation
-------------
    gem install hyperpublic_ruby


Sample Usage
-------------
    require 'hyperpublic'

    auth = Hyperpublic::OAuth.new("your_key", "your_secret")


###Working with Places
    places_client = Hyperpublic::Places.new(auth)

    # find a single place by ID
    place = places_client.find("4dd53bffe2f2d70816000001")

    # find places by a query
    places = places_client.find(:q => "chicken")

    # find places by a location
    places = places_client.find(:location => "416 w 13th st, New York")

    # find places by multiple criteria
    places = places_client.find(:category => "food", "postal_code" => 10012)

    # create a place
    places_client.create({:display_name => "Hyperpublic HQ",
                          :tags => ["place_tag1", "place_tag2"].join(","),
                          :image_url => "http://s3.amazonaws.com/prestigedevelopment/beta/image_photos/4dd535cab47dfd026c000002/square.png?1296938636",
                          :phone_number => "2124857375",
                          :website => "www.hyperpublic.com.com",
                          :category_id => "4e274d89bd0286830f000170",
                          :address => "416 w 13th st, New York, NY 10012",
                          :lat => 40.7405, 
                          :lon => -74.007})


###Working with Geodeals & Events
    offers_client = Hyperpublic::Offers.new(auth)

    # find a single offer by ID
    offer = offers_client.show("4e5e66f9a7ecee0001027a7b")

    # find offers by a query
    offers = offers_client.find(:q => "bowling")

    # find offers by a location
    offers = offers_client.find(:lat => 40.7, :lon => 74.0)

    # find offers by multiple criteria
    offers = offers_client.find(:source => "buywithme", :price_min => 10, :limit => 5)


###Working with Categories
      categories_client = Hyperpublic::Categories.new(auth)

      # get a list of categories
      categories = categories_client.find


Documentation
-------------
Visit our [developer site](http://developer.hyperpublic.com) for full documentation.
