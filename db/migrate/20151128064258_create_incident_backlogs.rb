class CreateIncidentBacklogs < ActiveRecord::Migration
  def up
    create_table :incident_backlogs do |t|
      t.integer :p1
      t.integer :p2
      t.integer :p3
      t.integer :p4
      t.integer :total
      t.date :operating_date

      t.timestamps
    end
  end
  def down
    drop_table :incident_backlogs
  end
end
