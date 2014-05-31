class Withdrawal < ActiveRecord::Base
  belongs_to :user
  has_one :payment_method

  def self.create_with_amount(user, amount, payment_method, options={})
    amount = BigDecimal.new(amount)
    return false if amount <= 0.0
    return false if amount >= 1500.0

    user.withdrawals << Withdrawal.create!(user: user, amount: -1 * amount)
    user.debit_from_balance(amount)

    begin
      transfer = Stripe::Transfer.create(
        :amount => amount.to_i * 100, # amount in cents
        :currency => "usd",
        :recipient => payment_method.stripe_recipient_id,
        :statement_description => "BUNJY WITHDRAWAL"
      )
    rescue Stripe::CardError => e
      return false
    end

    if user.save
      user.withdrawals.last
    else
      false
    end
  end
end
