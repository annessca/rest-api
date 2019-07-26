class Faculties < ActiveRecord::Migration[5.2]
  	def up
  		create_table :faculties do |t|
  			t.string :faculty_name
  			t.string :faculty_dean
  			t.string :faculty_email
  		end
  	end

  	def down
  		drop_table :faculties
  	end 
end
