class CreateAgeings < ActiveRecord::Migration
  def up
    create_table :ageings do |t|
      t.string :ageing
      t.integer :incident

      t.timestamps
    end
  end
  def down
    drop_table :ageings
  end
end
