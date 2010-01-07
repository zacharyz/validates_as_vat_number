require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Develon::ValidatesAsVies do
  it "is included" do
    class A < ActiveRecord::Base
      validates_as_vies :vat
    end
  end
  
  it "should validate Develon Company" do
    develon = Company.new(:name => 'Develon', :vat => 'IT03018900245')
    develon.valid?.should == true
  end
  
  it "should invalidate a fake company" do
    fake_company = Company.new(:name => 'Fake Company', :vat => 'IT000003018')
    fake_company.valid?.should == false
    fake_company.errors.on('vat').should_not == nil
  end
end