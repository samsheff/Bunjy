require 'spec_helper'

describe "Identity" do
  it "finds by provider and uid" do
    identity = create(:identity)
    Identity.find_with_omniauth({ 'provider' => 'facebook',
                                  'uid' => '12345'}
                               ).should == identity
  end

  it "creates using provider and uid" do
    identity = Identity.create_with_omniauth({ 
      'provider' => 'facebook',
      'uid' => '12345'}
    )
    identity.should be_a Identity
  end

  it "creates an identity if it doesnt exist" do
    Identity.find_or_create_with_omniauth({ 'provider' => 'facebook',
                                            'uid' => '12345' }
                                         ).should be_a Identity
  end 
end
