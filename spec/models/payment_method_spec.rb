require 'spec_helper'
require 'stripe_mock'

describe PaymentMethod do
  before do
    StripeMock.start
  end

  it "Knows if a payment method is for sending or withdrawaing" do
    send_method = build(:payment_method)
    withdraw_method = build(:payment_method)
    invalid_method = build(:payment_method)

    send_method.direction = -1
    withdraw_method.direction = 1

    invalid_method.inbound?.should == false
    invalid_method.outbound?.should == false    
    send_method.inbound?.should == false
    send_method.outbound?.should == true
    withdraw_method.inbound?.should == true
    withdraw_method.outbound?.should == false
  end

  it "creates a stripe customer" do
    payment_method = build(:payment_method)
    payment_method.create_stripe_customer.should be_a String
    payment_method.create_stripe_customer.should_not be_a Stripe::CardError
  end

  it "creates a stripe recipient" do
    payment_method = build(:payment_method)
    payment_method.create_stripe_recipient.should be_a String
    payment_method.create_stripe_recipient.should_not be_a Stripe::CardError
  end

  it "charges a card" do
    payment_method = build(:payment_method)
    payment_method.stripe_token = StripeMock.generate_card_token(last4: "9191",
                                                                 exp_year: 1984)
    payment_method.create_stripe_customer
    payment_method.charge_stripe_card(100.0).should eq true
  end

  it "transfers to a card" do
    payment_method = build(:payment_method)
    payment_method.stripe_token = StripeMock.generate_card_token(last4: "9191",
                                                                 exp_year: 1984)
    payment_method.create_stripe_recipient
    payment_method.withdraw_to_card(100.0).should eq true
  end
end
