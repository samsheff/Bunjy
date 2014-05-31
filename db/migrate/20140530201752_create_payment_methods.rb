class CreatePaymentMethods < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
      t.string :method_type
      t.string :name
      t.string :email
      t.string :method_type
      t.string :stripe_token
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
