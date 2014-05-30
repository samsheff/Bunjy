class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.belongs_to :user
      t.decimal :amount
      t.string :description
      t.decimal :fee
      t.string :action

      t.timestamps
    end

  end
end
