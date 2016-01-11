class CreateInflowVsClosures < ActiveRecord::Migration
  def up
    create_table :inflow_vs_closures do |t|
      t.integer :created
      t.integer :closed
      t.date :operating_date

      t.timestamps
    end
  end

  def down
    drop_table :inflow_vs_closures
  end
end
