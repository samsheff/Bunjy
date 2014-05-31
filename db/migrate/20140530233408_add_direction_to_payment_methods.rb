class AddDirectionToPaymentMethods < ActiveRecord::Migration
  def change
    add_column :payment_methods, :direction, :integer
  end
end
