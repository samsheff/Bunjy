class Withdrawal < ActiveRecord::Base
  belongs_to :user
  has_one :payment_method

  def self.create_with_amount(user, amount, payment_method, options={})
    amount = BigDecimal.new(amount)
    return false if amount <= 0.0
    return false if amount >= 1500.0

    withdrawal_status = payment_method.withdraw_to_card(amount)
    if withdrawal_status == true
      user.withdrawals << Withdrawal.create!(user: user, amount: -1 * amount)
      user.debit_from_balance(amount)

      if user.save
        return user.withdrawals.last
      else
        return false
      end
    else
      return withdrawal_status
    end
  end
end
