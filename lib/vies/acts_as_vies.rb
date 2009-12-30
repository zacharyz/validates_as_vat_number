require 'soap/wsdlDriver'
require 'activerecord'

module ActiveRecord
  module Acts

    module Vies
      def self.included(base)
        base.send :extend, ClassMethods
      end

      module ClassMethods
        def acts_as_vies
          send :include, InstanceMethods
        end
      end

      module InstanceMethods
        # any method placed here will apply to instaces, like @hickwall
      end
    end

  end
end


ActiveRecord::Base.send(:include, ActiveRecord::Acts::ActsAsVies)