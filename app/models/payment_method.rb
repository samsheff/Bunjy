class PaymentMethod < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :stripe_token, :name, :method_type

  def save_to_stripe
    self.create_stripe_customer if self.inbound?
    self.create_stripe_recipient if self.outbound?

    self.save
  end

  def inbound?
    return true if self.direction == 1
    false
  end

  def outbound?
    return true if self.direction == -1
    false
  end

  def create_stripe_customer
    begin
      customer = Stripe::Customer.create(
        :card => self.stripe_token,
        :description => "name"
      )
      self.stripe_customer_id = customer.id
    rescue Stripe::CardError => e
      return e
    end
  end

  def create_stripe_recipient
    begin
      recipient = Stripe::Recipient.create(
        :name => "Bunjy User",
        :type => "individual",
        :card => self.stripe_token
      )
      self.stripe_recipient_id = recipient.id
    rescue Stripe::CardError => e
      return e
    end
  end

  def charge_stripe_card(amount)
    begin
      Stripe::Charge.create(
        :amount => (amount * 100).to_i, # amount in cents
        :currency => "usd",
        :customer => self.stripe_customer_id,
        :description => "BUNJI"
      )
      return true
    rescue Stripe::CardError => e
      return e
    end
  end

  def withdraw_to_card(amount)
    begin
      Stripe::Transfer.create(
        :amount => (amount * 100).to_i, # amount in cents
        :currency => "usd",
        :recipient => self.stripe_recipient_id,
        :statement_description => "BUNJY WITHDRAWAL"
      )
      return true
    rescue Stripe::CardError => e
      return e
    end    
  end
end
