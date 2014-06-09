require 'spec_helper'
require 'stripe_mock'

describe Payment do

  before do
    StripeMock.start
  end
  
  it "gets created" do
    sender = build(:user)
    sender.balance += 100.0

    send_method = build(:payment_method)
    send_method.stripe_token = StripeMock.generate_card_token(last4: "9191",
                                                              exp_year: 1984)
    send_method.create_stripe_customer
    
    recipient = build(:user)
    recipient.email = "jtest@labs.com"

    payment = Payment.create_with_amount(sender, recipient, "50.0",
                               send_method)
    
    payment.should be_a Payment
    sender.balance.should == 50.0
    sender.balance.should_not == 100.0
    sender.payments.length.should > 0
    recipient.payments.length.should > 0
    recipient.balance.should == 50.0
  end

  it "knows if it was sent or recieved" do
    payment = build(:payment)
    payment.action_string.should == "Recieved"
    
    payment.amount = payment.amount * -1
    payment.action_string.should == "Sent"    
  end
end
