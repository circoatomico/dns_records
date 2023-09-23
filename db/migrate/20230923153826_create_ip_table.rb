class CreateIpTable < ActiveRecord::Migration[6.1]
  def change
    create_table :ip_addresses do |t|
      t.string :ip, null: false

    end
  end
end
