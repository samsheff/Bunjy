class User < ActiveRecord::Base
  rolify
  validates_presence_of :name

  has_many :payments

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
         user.name = auth['info']['name'] || ""
         user.email = auth['info']['email'] || ""
      end
      user.balance = 0.0
    end
  end

  def send_money_to(user, amount)
    Payment.create_with_amount(current_user, user, amount)
  end

  def debit_from_balance(amount)
    self.balance -= amount
  end

  def add_to_balance(amount)
    self.balance += amount
  end  
end
