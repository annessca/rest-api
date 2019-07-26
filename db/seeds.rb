# Populate the Faculty table.
puts 'Adding seed records to faculties table'
facultydata = [
	{faculty_name: 'Science', faculty_dean: 'Dove Fortune', faculty_email: 'science_faculty@ecollege.com'},
	{faculty_name: 'Engineering', faculty_dean: 'Krystal Rafe', faculty_email: 'engineering_faculty@ecollege.com'},
	{faculty_name: 'Medicine', faculty_dean: 'Deryk Tyrell', faculty_email: 'medicine_faculty@college.com'},
	{faculty_name: 'Arts', faculty_dean: 'Granville Delphia', faculty_email: 'art_faculty@ecollege.com'}
]

facultydata.each do |fty|
	Faculty.create(fty)
	puts 'Feeding in records...'
end
puts 'Faculties table initialized with seed data'


# Populate the Department table.
puts 'Adding seed records to departments table'
deptdata = [
	{dept_name: 'Chemical Sciences', dept_head: 'Petula Callahan', dept_email: 'chemical_sciences@ecollege.com', faculty: Faculty.where(faculty_name: 'Science').first},
	{dept_name: 'Computer Engineering', dept_head: 'Julie Rothwell', dept_email: 'computer_engineering.ecollege.com', faculty: Faculty.where(faculty_name: 'Engineering').first},
	{dept_name: 'Languages', dept_head: 'Knox Astor', dept_email: 'languages@ecollege.com', faculty: Faculty.where(faculty_name: 'Arts').first},
	{dept_name: 'Medical Sciences', dept_head: 'Norton Gisselle', dept_email: 'med_sciences@ecollege.com', faculty: Faculty.where(faculty_name: 'Medicine').first}
]

deptdata.each do |dpt|
	Department.create(dpt)
	puts 'Feeding in records...'
end
puts 'Departments table initialized with seed data'


# Populate the Course table.
puts 'Adding seed records to courses table'
coursedata = [
	{course_name: 'Software Engineering', course_duration: '10 Semesters', course_adviser: 'Danielle Jones', department: Department.where(dept_name: 'Computer Engineering').first},
	{course_name: 'French', course_duration: '8 Semesters', course_adviser: 'Joseph Merkel', department: Department.where(dept_name: 'Languages').first},
	{course_name: 'Industrial Chemistry', course_duration: '8 Semesters', course_adviser: 'Grace Brownson', department: Department.where(dept_name: 'Chemical Sciences').first},
	{course_name: 'Pharmacy', course_duration: '10 Semesters', course_adviser: 'Rylie Phillip', department: Department.where(dept_name: 'Medical Sciences').first}
]

coursedata.each do |crs|
	Course.create(crs)
	puts 'Feeding in records...'
end
puts 'Courses table initialized with seed data'

