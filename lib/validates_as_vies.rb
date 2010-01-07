module Develon
  module ValidatesAsVies
    require 'soap/wsdlDriver'

    def validates_as_vies(*attr_names)
      configuration = {
        :message   => 'is an invalid VAT number',
        :allow_nil => false 
      }
      configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)
      
      iso3661_country_codes = %w(AF AX AL DZ AS AD AO AI AQ AG AR AM AW AU AT AZ BS BH BD BB BY BE BZ BJ BM BT BO BA BW BV BR IO BN BG BF BI KH CM CA CV KY CF TD CL CN CX CC CO KM CG CD CK CR CI HR CU CY CZ DK DJ DM DO EC EG SV GQ ER EE ET FK FO FJ FI FR GF PF TF GA GM GE DE GH GI GR GL GD GP GU GT GG GN GW GY HT HM VA HN HK HU IS IN ID IR IQ IE IM IL IT JM JP JE JO KZ KE KI KP KR KW KG LA LV LB LS LR LY LI LT LU MO MK MG MW MY MV ML MT MH MQ MR MU YT MX FM MD MC MN ME MS MA MZ MM NA NR NP NL AN NC NZ NI NE NG NU NF MP NO OM PK PW PS PA PG PY PE PH PN PL PT PR QA RE RO RU RW BL SH KN LC MF PM VC WS SM ST SA SN RS SC SL SG SK SI SB SO ZA GS ES LK SD SR SJ SZ SE CH SY TW TJ TZ TH TL TG TK TO TT TN TR TM TC TV UG UA AE GB US UM UY UZ VU VE VN VG VI WF EH YE ZM ZW)

      validates_each(attr_names,configuration) do |record, attr_name, value|
        if iso3661_country_codes.include?(value[0,2].upcase)
          unless check_vat(value[0,2], value.gsub(/^\w\w/, '')) == true
            record.errors.add(attr_name, :not_valid, :default => configuration[:message])
          end
        else
          record.errors.add(attr_name, 'has an invalid country')
        end
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
  end
end

ActiveRecord::Base.extend Develon::ValidatesAsVies
