class Course < ActiveRecord::Base
	belongs_to :department

	validates :course_name, presence: true
	validates :course_duration, presence: true
	validates :course_adviser, presence: true
	validates :department_id, presence: true
end