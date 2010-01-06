require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ActiveRecord::Acts::Vies do
  before(:each) do
    @company = Company.new(:name => 'Develon', :country => 'IT', :vat => '03018900245')
  end
  
  it "exists" do
    ActiveRecord::Acts::Vies.class
  end
  
  it "should respond to checkVat" do
    @company.should respond_to(:checkVat)
  end
  
  it "should validate Develon company" do
    @company.is_vat_valid?.should == true
  end
end
