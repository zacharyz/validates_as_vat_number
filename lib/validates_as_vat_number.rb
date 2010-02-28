module Develon
  module ValidatesAsVatNumber
    require 'soap/wsdlDriver'

    def validates_as_vat_number(*attr_names)
      configuration = {
        :message   => 'is an invalid VAT number',
        :allow_nil => false 
      }
      configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)
      
      iso3661_country_codes = %w(AF AX AL DZ AS AD AO AI AQ AG AR AM AW AU AT AZ BS BH BD BB BY BE BZ BJ BM BT BO BA BW BV BR IO BN BG BF BI KH CM CA CV KY CF TD CL CN CX CC CO KM CG CD CK CR CI HR CU CY CZ DK DJ DM DO EC EG SV GQ ER EE ET FK FO FJ FI FR GF PF TF GA GM GE DE GH GI GR GL GD GP GU GT GG GN GW GY HT HM VA HN HK HU IS IN ID IR IQ IE IM IL IT JM JP JE JO KZ KE KI KP KR KW KG LA LV LB LS LR LY LI LT LU MO MK MG MW MY MV ML MT MH MQ MR MU YT MX FM MD MC MN ME MS MA MZ MM NA NR NP NL AN NC NZ NI NE NG NU NF MP NO OM PK PW PS PA PG PY PE PH PN PL PT PR QA RE RO RU RW BL SH KN LC MF PM VC WS SM ST SA SN RS SC SL SG SK SI SB SO ZA GS ES LK SD SR SJ SZ SE CH SY TW TJ TZ TH TL TG TK TO TT TN TR TM TC TV UG UA AE GB US UM UY UZ VU VE VN VG VI WF EH YE ZM ZW)
      
      structures = { 'AT' => /^ATU\w{8}$/, 'BE' => /^BE0\d{9}$/, 'BG' => /^BG\d{9,10}$/, 'CY' => /^CY\w{8}L$/,
                     'CZ' => /^CZ\d{8,10}$/, 'DE' => /^DE\d{9}$/, 'DK' => /^DK\d{2}\s\d{2}\s\d{2}\s\d{2}$/,
                     'EE' => /^EE\d{9}$/, 'EL' => /^EL\d{9}$/, 'ES' => /^ESX\d{7}X$/, 'FI' => /^FI\d{8}$/, 'FR' => /^FR\w{2}\s\d{9}$/,
                     'GB' => /^GB(\d{3}\s\d{4}\s\d{2}|\d{3}\s\d{4}\s\d{2}\s\d{3}|GD\d{3}|HA\d{3})$/,
                     'HU' => /^HU\d{8}$/, 'IE' => /^IE\wS\w{5}L$/, 'IT' => /^IT\d{11}$/, 'LT' => /^LT(\d{9}|\d{12})$/,
                     'LU' => /^LU\d{8}$/, 'LV' => /^LV\d{12}$/, 'MT' => /^MT\d{8}$/, 'NL' => /^NL\w{9}B\w{2}$/,
                     'PL' => /^PL\d{10}$/, 'PT' => /^PT\d{9}/, 'RO' => /^RO\d{2,10}$/, 'SE' => /^SE\d{12}$/, 'SI' => /^SI\d{8}$/,
                     'SK' =>/^SK\d{10}$/ }

      validates_each(attr_names,configuration) do |record, attr_name, value|
        country = country_code(value)
        if structures.include?(country)
          message = configuration[:message] unless structures[country].match(value) && check_vat(country, value.gsub(/^\w\w/, ''))
        else
          message = 'has an invalid country'
        end
        record.errors.add(attr_name, :not_valid, :default => message) unless message.nil?
      end
    end

    protected

    def vies_driver
      wsdl = "http://ec.europa.eu/taxation_customs/vies/api/checkVatPort?wsdl"
      @driver = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver
    end

    def check_vat(country_code, vat_number)
      @driver = vies_driver unless @driver
      @driver.checkVat(:countryCode => country_code, :vatNumber => vat_number).valid == 'true'
    end
    
    def country_code(vat)
      vat[0,2].upcase
    end
  end
end

ActiveRecord::Base.extend Develon::ValidatesAsVatNumber
