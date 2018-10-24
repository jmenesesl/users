class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :id_permalink
      t.string :email
      t.string :usertype
      t.string :creations
      t.string :credit_subscription
      t.datetime :creation_date
      t.timestamps
    end
  end
end
