## validates_as_vat_number

Now you can validate VAT using the European service called [VIES](http://ec.europa.eu/taxation_customs/vies/services/checkVatService?wsdl), to ensure it exists. Only require this gem and call validate_as_vat_number on your VAT field, in an Active Record object.

## Install 

Specify it in your Rails config.

    config.gem 'validates_as_vat_number', :source => 'http://gemcutter.org'

Then install it.

    rake gems:install

## Example


    class Company < ActiveRecord::Base
    	validates_as_vat_number :vat
    end

## Acknowledgements
Thanks to [sborsje](http://github.com/sborsje) for fixing the instance with valid ISO 3660 but unsupported codes.

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2009 Develon. See LICENSE for details.
