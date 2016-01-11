class CreateStatusForOpenTickets < ActiveRecord::Migration
  def up
    create_table :status_for_open_tickets do |t|
      t.integer :assigned
      t.integer :awaiting_change
      t.integer :monitor
      t.integer :pending_customer
      t.integer :pending_supplier
      t.integer :pending_telstra
      t.integer :update_received
      t.integer :work_in_progress
      t.date :uploaded_at

      t.timestamps
    end
  end

  def down
    drop_table  :status_for_open_tickets
  end
end
