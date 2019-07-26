class Department < ActiveRecord::Base
	belongs_to :faculty
	has_many :courses, dependent: :destroy

	validates :dept_name, presence: true
	validates :dept_head, presence: true
	validates :dept_email, presence: true
	validates :faculty_id, presence: true
end