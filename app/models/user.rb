class User < ActiveRecord::Base
  rolify
  validates_presence_of :name, :balance
  validates_uniqueness_of :email

  has_many :payments
  has_many :withdrawals
  has_many :payment_methods

  def self.create_with_omniauth(auth)
    user = User.find_by_uid(auth['uid'])
    if user
      session[:user_id] = user.id
    else
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
  end

  def self.find_by_email(email)
    User.where(email: email).first
  end

  def self.find_by_uid(uid)
    User.where(uid: uid).first
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
