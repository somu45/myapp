class CreateUnsuccessfulChanges < ActiveRecord::Migration
  def up
    create_table :unsuccessful_changes do |t|
      t.integer :unsuccessful_changes
      t.date :operating_date
      t.date :uploaded_at

      t.timestamps
    end
  end

  def down
    drop_table :unsuccessful_changes
  end
end
