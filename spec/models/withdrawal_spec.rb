require 'spec_helper'
require 'stripe_mock'

describe Withdrawal do
  before do
    StripeMock.start
  end

  it "creates with an amount" do
    user = create(:user)
    user.balance += 200.0

    payment_method = build(:payment_method)
    payment_method.stripe_token = StripeMock.generate_card_token(last4: "9191",
                                                                 exp_year: 1984)
    payment_method.method_type = "card"
    payment_method.create_stripe_recipient
    payment_method.save!
    
    withdrawal = Withdrawal.create_with_amount(user, "100.0", payment_method)
    
    withdrawal.should_not == false
    withdrawal.should be_a Withdrawal
    withdrawal.amount.should == -100.0
    withdrawal.user.should == user
    withdrawal.should_not be_a String
  end
end
