class CreateHostnameTable < ActiveRecord::Migration[6.1]
  def change
    create_table :hostnames do |t|
      t.string :hostname, null: false
    end
  end
end
