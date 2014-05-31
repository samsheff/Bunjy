class AddStripeRecipientId < ActiveRecord::Migration
  def change
    add_column :payment_methods, :stripe_recipient_id, :string
  end
end
