class CreateIpHostnameTable < ActiveRecord::Migration[6.1]
  def change
    create_table :ip_hostnames do |t|
      t.references :ip_address, null: false, foreign_key: true
      t.references :hostname, null: false, foreign_key: true
    end
  end
end