require 'sinatra'
require 'sinatra/activerecord'
require "sinatra/namespace"
require './environments'
require './models/faculty'
require './models/department'
require './models/course'
require 'json'


namespace '/ecollege/api/v1' do 
	#Code goes here

	before do
		content_type 'application/json'
	end

	# API root endpoint

	get '/' do
		#Code goes here
		'This is the official e-College API'
	end

	# GET Requests
	get '/faculties' do
		# Request to retrieve all faculties.
		facs = Faculty.all
		facs.to_json(include: :departments)
	end

	get '/departments' do 
		# Request to retrieve all departments.
		depts = Department.all
		depts.to_json(include: :courses)
	end

	get '/courses' do
		# Request to retrieve all courses.
		courses = Course.all
		courses.to_json
	end

	# GET Requests by ID
	get '/faculties/:id' do |id|
		# Requests a single faculty.
		faculty = Faculty.where(id: id).first
		unless faculty
			halt 404, {message: 'Resource Not Found'}.to_json
		else
			faculty.to_json(include: :departments)
		end
	end

	get '/departments/:id' do |id|
		# Requests a single department.
		dept = Department.where(id: id).first
		unless dept
			halt 404, {message: 'Resource Not Found'}.to_json
		else
			dept.to_json(include: :courses)
		end
	end

	get '/courses/:id' do |id|
		# Requests a single course.
		course = Course.where(id: id).first
		unless course
			halt 404, {message: 'Resource Not Found'}.to_json
		else
			course.to_json
		end
	end

	# POST Requests
	post '/faculties' do
		#Requests to create a new resource in faculties
		payload = JSON.parse(request.body.read)

		if !payload
			halt 422, {message: 'Inoperable Request'}.to_json
		else
			Faculty.new(payload).save
			{message: 'Resource Successfully Created'}.to_json
		end
	end

	post '/departments' do
		#Requests to create a new resource in departments
		payload = JSON.parse(request.body.read)

		if !payload
			halt 422, {message: 'Inoperable Request'}.to_json
		else
			Department.new(payload).save
			{message: 'Resource Successfully Created'}.to_json
		end
	end

	post '/courses' do
		#Requests to create a new resource in courses
		payload = JSON.parse(request.body.read)

		if !payload
			halt 422, {message: 'Inoperable Request'}.to_json
		else
			Course.new(payload).save
			{message: 'Resource Successfully Created'}.to_json
		end
	end

	# PUT Requests
	put '/faculties/:id' do |id|
		#Requests to update Faculty resource with new data
		faculty = Faculty.where(id: id).first
		payload = JSON.parse(request.body.read)
		if !faculty
			halt 404, {message: 'Resource not found'}.to_json
		elsif payload
			faculty.update_attributes(payload)
			{message: 'Resource Updated'}.to_json
		else
			halt 422, {message: 'Inoperable Request'}.to_json
		end
	end

	put '/departments/:id' do |id|
		#Requests to update Department resource with new data
		department = Department.where(id: id).first
		payload = JSON.parse(request.body.read)
		if !department
			halt 404, {message: 'Resource not found'}.to_json
		elsif payload
			department.update_attributes(payload)
			{message: 'Resource Updated'}.to_json
		else
			halt 422, {message: 'Inoperable Request'}.to_json
		end
	end

	put '/courses/:id' do |id|
		#Requests to update Course resource with new data
		course = Course.where(id: id).first
		payload = JSON.parse(request.body.read)
		if !course
			halt 404, {message: 'Resource not found'}.to_json
		elsif payload
			course.update_attributes(payload)
			{message: 'Resource Updated'}.to_json
		else
			halt 422, {message: 'Inoperable Request'}.to_json
		end
	end

	delete '/faculties/:id' do |id|
		#Request to delete a single faculty
  		faculty = Faculty.where(id: id).first
  		if faculty
  			faculty.destroy
    		{message: "Resource Deleted"}.to_json
  		else
   			halt 500, {message: 'Server Error'}.to_json
  		end
  	end

  	delete '/departments/:id' do |id|
  		#Request to delete a single department
  		department = Department.where(id: id).first

  		if department
  			department.destroy
    		{message: "Resource Deleted"}.to_json
  		else
   			halt 500, {message: 'Server Error'}.to_json
  		end
	end

	delete '/courses/:id' do |id|
		#Request to delete a single course
  		course = Course.where(id: id).first

  		if course
  			course.destroy
    		{message: "Resource Deleted"}.to_json
  		else
   			halt 500, {message: 'Server Error'}.to_json
  		end
	end

	after do
  		# Close the ActiveRecord connection pool.
  		ActiveRecord::Base.connection.close
	end

end