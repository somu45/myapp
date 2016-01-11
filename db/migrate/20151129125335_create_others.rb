class CreateOthers < ActiveRecord::Migration
  def up
    create_table :others do |t|
      t.integer :created
      t.integer :closed
      t.date :operating_date
      t.date :uploaded_at

      t.timestamps
    end
  end

  def down
    drop_table :others
  end
end
