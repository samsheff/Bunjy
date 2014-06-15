class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :setting_name
      t.string :setting_value
      t.string :data_type

      t.timestamps
    end
  end
end
