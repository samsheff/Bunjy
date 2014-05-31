class AddStripeCustomerId < ActiveRecord::Migration
  def change
    add_column :payment_methods, :stripe_customer_id, :string
  end
end
