class CreateOtherBacklogs < ActiveRecord::Migration
  def up
    create_table :other_backlogs do |t|
      t.integer :backlogs
      t.date :operating_date
      t.date :uploaded_at

      t.timestamps
    end
  end

  def down
    drop_table :other_backlogs
  end
end
