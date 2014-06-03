class Payment < ActiveRecord::Base
  belongs_to :user
  has_one :payment_method

  def self.create_with_amount(sender, recipient, amount,
                              payment_method, options={})
    amount = BigDecimal.new(amount)
    return false if amount <= 0.0
    return false if amount >= 1500.0
    #return false if sender.email == recipient.email

    sender.payments << Payment.create!(user: sender, amount: -1 * amount,
                                     description: options[:description],
                                     action: "sent")
    return false unless payment_method.charge_stripe_card(amount)
    sender.debit_from_balance(amount)

    recipient.payments << Payment.create!(user: sender, amount: amount,
                                          description: options[:description],
                                          action: "recieved")
    recipient.add_to_balance(amount)

    if recipient.save and sender.save
      sender.payments.last
    else
      false
    end
  end

  def action_string
    return "Sent" if self.amount < 0.0
    "Recieved"
  end
end
