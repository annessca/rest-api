class Faculty < ActiveRecord::Base
	has_many :departments, dependent: :destroy

	validates :faculty_name, presence: true
	validates :faculty_dean, presence: true
	validates :faculty_email, presence: true
end