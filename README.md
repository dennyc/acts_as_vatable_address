# ActsAsVatableAddress

This gem aims to help you building a billing or accounting system with Ruby on Rails. Use `acts_as_vatable_address` with any ActiveRecord model which has some address attributes (at least postal code and country) to find out whether VAT (sales tax / turnover tax) needs to be added or not.

At the moment, this is for EU countries only.

Please note: This gem is in a very early state. So take a look at the code before using it and check if it will do what you want.

## Installation

Add this line to your application's Gemfile:

    gem 'acts_as_vatable_address', github: 'dennyc/acts_as_vatable_address'

And then execute:

    $ bundle

## Usage

Add `acts_as_vatable_address` to your model and provide a two character ISO code of the sender address.

    class DeliveryAddress < ActiveRecord::Base
      acts_as_vatable_address :de
      ...
    end
  
By default, the gem looks for `post code` and `country` methods to retrieve all the necessary information. You can change this to the methods/columns of your model.

    class DeliveryAddress < ActiveRecord::Base
      acts_as_vatable_address :de, country: nation, post code: zip
      ...
    end

Now you can use following instance methods:

    home_country? # true if domestic address
    
    home_country_third_country_territory? # true if domestic address but on a third country territory 
    
    home_country_without_third_country_territory? # true if domestic address and outside of a third country territory
    
    eu? # true if address is within EU (including home country)

    eu_third_country_territory? # true if EU address but on a third country territory

    eu_without_third_country_territory? # true if EU address and outside a third country territory

    eu_without_home_country? # true if address is within EU but abroad

    third_country? # true for every country outside of EU 

Please note: 'third country territory' refers to EU VAT regulation only. Those rules don't apply to duty concerns. 

Create your documents, accounting data, etc. based on the output of those instance methods.

There is also a basic `vatable?` method which evaluates the need to claim VAT. 

    def vatable?
      home_country_without_third_country_territory? 
    end

You might want to customize the rules (e.g. add a VAT number validation) by overwriting the method in your model.

    class DeliveryAddress < ActiveRecord::Base
      acts_as_vatable_address :fr, postcode: postal_code

      def vatable?
        home_country? || (eu_without_home_country? && !vat_id_valid?)
      end
    end

## Caveats

The most important ones:

* Currently, the country value needs to be in English. There's a YAML file inside the gem where you can easily add translations.
* There are only three EU third country territories stored yet: Helgoland, Büsingen (both Germany) and Canary Islands (Spain)

## TODO

* Remove ActiveRecord requirement
* Move country stuff to own module
* Enhance error handling

## Contributing

1. Fork it ( http://github.com/dennyc/acts_as_vatable_address/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request