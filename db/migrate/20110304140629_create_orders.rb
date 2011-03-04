class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :cart_id
      t.string :name
      t.string :address
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
