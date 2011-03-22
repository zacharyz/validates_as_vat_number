module Develon
  module ValidatesAsVatNumber
    require 'savon'

    def validates_as_vat_number(*attr_names)
      configuration = {
        :message   => 'is an invalid VAT number',
        :allow_nil => false 
      }
      configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)
      
      structures = {'AT' => /^ATU\w{8}$/, 'BE' => /^BE0\d{9}$/, 'BG' => /^BG\d{9,10}$/, 'CY' => /^CY\d{8}\w{1}$/,
                          'CZ' => /^CZ\d{8,10}$/, 'DE' => /^DE\d{9}$/, 'DK' => /^DK\d{8}$/, 'EE' => /^EE\d{9}$/,
                          'EL' => /^EL\d{9}$/, 'ES' => /^ES(\d{8}[A-Za-z]{1}|[A-Za-z]{1}\d{8}|[A-Za-z]{1}\d{7}[A-Za-z]{1})$/,
                          'FI' => /^FI\d{8}$/, 'FR' => /^FR\w{2}\d{9}$/, 'GB' => /^GB(\d{9}|\d{12}|(GD|HA)\d{3})$/,
                          'HU' => /^HU\d{8}$/, 'IE' => /^IE\d{1}[\w+*]{1}\d{5}[A-Za-z]{1}$/, 'IT' => /^IT\d{11}$/,
                          'LT' => /^LT(\d{9}|\d{12})$/, 'LU' => /^LU\d{8}$/, 'LV' => /^LV\d{11}$/, 'MT' => /^MT\d{8}$/,
                          'NL' => /^NL\d{9}B\d{2}$/, 'PL' => /^PL\d{10}$/, 'PT' => /^PT\d{9}/, 'RO' => /^RO\d{2,10}$/,
                          'SE' => /^SE\d{12}$/, 'SI' => /^SI\d{8}$/, 'SK' =>/^SK\d{10}$/
            }

      validates_each(attr_names,configuration) do |record, attr_name, value| 
        country = country_code(value)
        if structures.include?(country)
          message = configuration[:message] unless structures[country].match(value)
        else
          message = 'has an invalid country'
        end
        record.errors.add(attr_name, :not_valid, :default => message) unless message.nil?
      end
    end

    protected

    def vies_driver
      @driver = Savon::Client.new do
        #wsdl.document = "http://ec.europa.eu/taxation_customs/vies/services/checkVatService?wsdl" 
        wsdl.document = "http://ec.europa.eu/taxation_customs/vies/checkVatService.wsdl"
      end
    end
    

    def check_vat(country_code, vat_number)  
      @driver = vies_driver unless @driver  
      #@driver.check_vat { |soap| soap.body = { :country_code => country_code, :vat_number => vat_number } }.to_hash[:check_vat_response][:valid]
      response = @driver.request :check_vat do
        soap.body = { :country_code => country_code, :vat_number => vat_number }
      end   
      
      response.to_hash
    end
    
    def country_code(vat)
      vat[0,2].upcase
    end
  end
end

ActiveRecord::Base.extend Develon::ValidatesAsVatNumber
