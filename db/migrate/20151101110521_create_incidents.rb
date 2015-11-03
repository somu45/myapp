class CreateIncidents < ActiveRecord::Migration
  def change
    create_table :incidents do |t|
      t.string :customer
      t.string :infra
      t.string :device_name
      t.string :service_no
      t.string :domain
      t.string :management_id
      t.text :public_ip
      t.string :ilo_ip
      t.string :roles
      t.string :server_owners
      t.string :connectivity
      t.string :location_site
      t.string :location_rack
      t.string :vendor
      t.string :model
      t.string :os_ios
      t.string :technology
      t.string :support_vendor
      t.string :ram
      t.string :cpu
      t.string :cpu_speed
      t.string :database
      t.string :database_version
      t.string :serial_number
      t.integer :type_id

      t.timestamps
    end
  end
end
