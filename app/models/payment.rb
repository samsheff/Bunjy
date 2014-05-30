class Payment < ActiveRecord::Base
  belongs_to :user

  def self.create_with_amount(sender, recipient, amount, options={})
    return false if amount <= 0.0

    sender.payments << Payment.create!(user: sender, amount: -1 * amount,
                                     description: options[:description],
                                     action: "sent")
    sender.debit_from_balance(amount)

    recipient.payments << Payment.create!(user: sender, amount: amount,
                                          description: options[:description],
                                          action: "recieved")
    recipient.add_to_balance(amount)

    sender.save!
    recipient.save!
  end
end
