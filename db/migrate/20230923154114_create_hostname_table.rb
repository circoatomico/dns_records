class CreateHostnameTable < ActiveRecord::Migration[6.1]
  def change
    create_table :hostname_tables do |t|
      t.string :hostname, null: false
      t.references :ip_table, null: false, foreign_key: true

      t.timestamps
    end
  end
end
