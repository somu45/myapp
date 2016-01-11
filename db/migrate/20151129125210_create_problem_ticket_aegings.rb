class CreateProblemTicketAegings < ActiveRecord::Migration
  def up
    create_table :problem_ticket_aegings do |t|
      t.string :days
      t.integer :number
      t.date :uploaded_at

      t.timestamps
    end
  end

  def down
    drop_table :problem_ticket_aegings
  end
end
