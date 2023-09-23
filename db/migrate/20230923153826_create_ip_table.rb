class CreateIpTable < ActiveRecord::Migration[6.1]
  def change
    create_table :ip_tables do |t|
      t.string :ip_address, null: false

      t.timestamps
    end
  end
end
