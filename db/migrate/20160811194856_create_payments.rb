class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.float :amount, null: false
      t.string :status, null: false
    end
  end
end
