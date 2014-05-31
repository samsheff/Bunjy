class PaymentMethod < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :stripe_token, :name, :method_type

  def save_to_stripe
    if self.inbound?
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

    if self.outbound?
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

    self.save!
  end

  def inbound?
    return true if self.direction == 1
    false
  end

  def outbound?
    return true if self.direction == -1
    false
  end
end
