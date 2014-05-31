class CreateWithdrawals < ActiveRecord::Migration
  def change
    create_table :withdrawals do |t|
      t.belongs_to :user, index: true
      t.decimal :amount

      t.timestamps
    end
  end
end
