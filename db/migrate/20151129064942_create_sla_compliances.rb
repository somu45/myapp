class CreateSlaCompliances < ActiveRecord::Migration
  def up
    create_table :sla_compliances do |t|
      t.integer :target_sla
      t.integer :adjusted_sla
      t.integer :unadjusted_sla
      t.date :operating_date

      t.timestamps
    end
  end
  def down
    drop_table :sla_compliances
  end
end
