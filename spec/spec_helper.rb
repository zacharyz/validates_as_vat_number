$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'active_record'
require 'spec'
require 'spec/autorun'

require File.join(File.dirname(__FILE__), '..', 'init')

Spec::Runner.configure do |config|
  
end

class Company < ActiveRecord::Base
  acts_as_vies
  
  def self.columns() @columns ||= []; end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end

  column :name, :string
  column :country, :string
  column :vat, :string
end
