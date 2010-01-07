module Develon
  module ValidatesAsVies
    require 'soap/wsdlDriver'

    def validates_as_vies(*attr_names)
      configuration = {
        :message   => 'is an invalid VAT number',
        :allow_nil => false 
      }
      configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)
      
      validates_each(attr_names,configuration) do |record, attr_name, value|
       unless check_vat(value[0,2], value.gsub(/^\w\w/, '')) == true
          record.errors.add(attr_name, :not_valid, :default => configuration[:message])
        end
      end
    end
    
    protected
    
    def vies_driver
      wsdl = "http://ec.europa.eu/taxation_customs/vies/api/checkVatPort?wsdl"
      SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver
    end
    
    def check_vat(country_code, vat_number)
      vies_driver.checkVat(:countryCode => country_code, :vatNumber => vat_number).valid == 'true'
    end
  end
end

ActiveRecord::Base.extend Develon::ValidatesAsVies
