class Departments < ActiveRecord::Migration[5.2]
  def up
  	create_table :departments do |t|
  		t.string :dept_name
  		t.string :dept_head
  		t.string :dept_email
  		t.references :faculty, foreign_key: true
  	end
  end

  def down
  	drop_table :departments
  end
end
