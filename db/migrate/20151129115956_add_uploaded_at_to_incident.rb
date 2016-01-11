class AddUploadedAtToIncident < ActiveRecord::Migration
  def up
    add_column :incidents, :uploaded_at, :date
    add_column :inflow_vs_closures, :uploaded_at, :date
    add_column :incident_backlogs, :uploaded_at, :date
    add_column :ageings, :uploaded_at, :date
    add_column :sla_compliances, :uploaded_at, :date
  end
  def down
    remove_column :incidents, :uploaded_at
    remove_column :inflow_vs_closures, :uploaded_at
    remove_column :incident_backlogs, :uploaded_at
    remove_column :ageings, :uploaded_at
    remove_column :sla_compliances, :uploaded_at
  end
end
