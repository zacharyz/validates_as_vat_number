$:.unshift "#{File.dirname(__FILE__)}/lib"
require 'active_record/acts/vies'
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::Vies }