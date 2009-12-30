require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'rubygems'
require 'active_record'

describe ActiveRecord::Acts::Vies do
  it "is included" do
    class A < ActiveRecord::Base
      acts_as_vies
    end
  end
end