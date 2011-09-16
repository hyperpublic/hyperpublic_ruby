#The Hyperpublic Ruby Gem
======================

A Ruby wrapper for the Hyperpublic REST API


#Installation
----------------
    gem install hyperpublic_ruby


#Sample Usage
----------------
###Working with Places
    require 'hyperpublic'

      auth = Hyperpublic::OAuth.new("your_key", "your_secret")
      places_client = Hyperpublic::Places.new(auth)

      #find a single place by ID
      place = places_client.find("4dd53bffe2f2d70816000001")

      #find places by a query
      places = places_client.find(:q => "chicken")

      #find places by a location
      places = places_client.find(:location => "416 w 13th st, New York")

      #find places by multiple criteria
      places = places_client.find(:category => "food", "postal_code" => 10012)

      #create a place
      places_client.create({:display_name => "Hyperpublic HQ",
                            :tags => ["place_tag1", "place_tag2"].join(","),
                            :image_url => "http://s3.amazonaws.com/prestigedevelopment/beta/image_photos/4dd535cab47dfd026c000002/square.png?1296938636",
                            :phone_number => "2124857375",
                            :website => "www.hyperpublic.com.com",
                            :category_id => "4e274d89bd0286830f000170",
                            :address => "416 w 13th st, New York, NY 10012",
                            :lat => 40.7405, 
                            :lon => -74.007})


###Working with Categories
      #get a list of categories
      categories_client = Hyperpublic::Categories.new(auth)
      categories = categories_client.find


#Documentation
---------------
visit our [developer site](http://developer.hyperpublic.com) for more information.
