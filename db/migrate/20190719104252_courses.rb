class Courses < ActiveRecord::Migration[5.2]
  def up
  	create_table :courses do |t|
  		t.string :course_name
  		t.string :course_adviser
  		t.string :course_duration
  		t.references :department, foreign_key: true
  	end
  end

  def down
  	drop_table :courses
  end
end
