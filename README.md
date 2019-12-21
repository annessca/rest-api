# How to implement REST with Sinatra, ActiveRecord, and PostgreSQL

[REST](https://www.codecademy.com/articles/what-is-rest) is a Standards architecture that allows [stateless](https://restfulapi.net/statelessness/) communications between computer systems and the web. RESTful web applications separate client implementations from those of the server.


[Sinatra](http://sinatrarb.com/intro.html) is a lightweight, rack-based, and [domain-specific language(DSL)](https://en.wikipedia.org/wiki/Domain-specific_language) that serves as a framework for creating web applications. Comparatively, Sinatra is simplistic and more straightforward to learn than Ruby.  This unarguably makes it a good starting point at getting acquainted with routes and endpoints. 

Web applications built with [Sinatra](http://sinatrarb.com/intro.html) are great at receiving targeted information from APIs and serving them to clients. They can make and receive [HTTP requests](https://www.toolsqa.com/client-server/http-request/) over [API endpoints](https://smartbear.com/learn/performance-monitoring/api-endpoints/) that define routes to application resources. Sinatra is a good choice if you are building minimal web applications and business APIs. So we'll build a RESTful web application that can make [GET, POST, PUT, and DELETE](https://developers.evrythng.com/docs/http-verbs-and-error-codes) requests to a college API using:

* [Sinatra](http://sinatrarb.com/): a web framework 
* [PostgreSQL](https://www.postgresql.org/): a Relational Database Management System
* [ActiveRecord](https://crypto.stanford.edu/cs142/lectures/activeRecord.html): an Object-Relational Model

## Getting started

This tutorial assumes you have installed Ruby. If you don't have it installed already, head to [ruby-lang.org](https://www.ruby-lang.org/en/downloads/), follow the installation guide to choose a tool that suits your operating system needs. 

Now that you have Ruby, open a terminal and run the command: `gem install bundler`

The [bundler](https://bundler.io/) gem is needed to download and install other Ruby [gems/libraries](https://www.ruby-lang.org/en/libraries/) that you require for your project from https://rubygems.org. 

## Setting up a Gemfile

Create a new projeect directory and name it "__e-college__". You can do that by running `mkdir e-college`. Navigate into the directory from your terminal and run `bundle init` to create a [Gemfile](https://bundler.io/gemfile.html).

Some additional libraries we'll require are:
* [sinatra-activerecord](https://github.com/janko/sinatra-activerecord) - provides extension methods for Sinatra to work with the ActiveRecord ORM and access to rake tasks.
* [rake](https://subscription.packtpub.com/book/hardware_and_creative/9781783280773/1) - schedules automated tasks.
* [shotgun](https://github.com/rtomayko/shotgun) - a command that reloads applications automatically.
Let's now populate the [Gemfile](https://bundler.io/gemfile.html) with gem dependencies needed for the project by updating it with the following.

```ruby
# Gemfile

gem 'sinatra'
gem 'activerecord'
gem 'sinatra-activerecord'
gem 'sinatra-contrib'
gem 'json'
gem 'pg'
gem 'rake'

group :development do
    gem 'shotgun'
end
```

After you've added [gems](https://www.ruby-lang.org/en/libraries/) to the [Gemfile](https://bundler.io/gemfile.html), run `bundle install`. 

This creates an additional Gemfile having a '__LOCK file__' type. The file contains your gems' unique dependencies equally downloaded and installed.

The [shotgun](https://github.com/rtomayko/shotgun) gem causes the server to automatically refresh itself whenever changes are made on either the client or server sides of the application.  But for Windows users, an alternative library that offers the same functionality is the [rerun](https://github.com/alexch/rerun) gem. This is because shotgun does not work on the Windows operating system. Also, if you have trouble installing the [pg](https://rubygems.org/gems/pg/versions/0.18.4) gem on a mac os, follow this [link](https://stackoverflow.com/questions/19625487/impossible-to-install-pg-gem-on-my-mac-with-mavericks/19850273#19850273) for a workaround solution.

## Setup a Rack configuration
Let's begin the setup by creating a file named "__app.rb__" at the root of the directory. The file should contain the application's server logic.

```ruby
# app.rb

require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/namespace'
require './environments'
require './models/faculty'
require './models/department'
require './models/course'
require 'json'
```

After that, create another file "__config.ru__" and add the following code to it.

```ruby
# config.ru

require './app'
run Sinatra::Application
```

The [Rack](https://rack.github.io/) is a Ruby server interface that connects the application to the web. An application is called to run from the '__config.ru__' file, as shown in the above code snippet. When you run `rackup config.ru` or `shotgun config.ru` at the terminal, it immediately executes the application.


## Environment file configuration

Create another ruby file at the root directory and name it "__environment.rb__". Copy the code below to the file and save. Also provide the username, password, host, and a name for your database. I called mine "__ecollege__".

```ruby
# environments.rb

configure :production, :development do
    set :show_exceptions, true
    db = URI.parse(ENV['DATABASE_URL'] ||'postgres://youruser:yourpassword@yourhost/ecollege')
    ActiveRecord::Base.establish_connection(
        adapter: db.scheme == 'postgres' ? 'postgresql' : db.scheme,
        host: db.host,
        username: db.user,
        password: db.password,
        database: db.path[1..-1],
        encoding: 'utf8'
    )
end
```

## Create a Rake file

Tasks are specified on the "__Rakefile__". It is simply "__Rakefile__" with no extensions, placed at the root of your directory. When there are multiple tasks to schedule, you may specify all of them in a "namespace". Although our Rakefile does not have any tasks specified, it is needed to require the rake gem every time an unspecified [rake task](https://www.rubyguides.com/2019/02/ruby-rake/) is run.

```ruby
# Rakefile

require 'sinatra/activerecord/rake'
require './app.rb'
```

## Define Database Models

We're using the [relational model](https://searchdatamanagement.techtarget.com/definition/relational-database) to define the structure and behaviour of our [database](https://www.techopedia.com/definition/6762/database-model). It will contain three tables who's relationship is indicated by foreign keys. Create a new folder in the root directory and call it ‘models’. The following files should go into it.

```ruby
# faculty.rb

class Faculty < ActiveRecord::Base
    has_many :departments, dependent: :destroy

    validates :faculty_name, presence: true
    validates :faculty_dean, presence: true
    validates :faculty_email, presence: true
end

# department.rb

class Department < ActiveRecord::Base
    belongs_to :faculty
    has_many :courses, dependent: :destroy

    validates :dept_name, presence: true
    validates :dept_head, presence: true
    validates :faculty_id, presence: true
end

# course.rb

class Course < ActiveRecord::Base
    belongs_to :department
    validates :course_name, presence: true
    validates :course_duration, presence: true
    validates :course_adviser, presence: true
    validates :department_id, presence: true
end
```

[Associations](https://guides.rubyonrails.org/association_basics.html) are established with the use of "__belongs_to__" and "__has_many__". These associations determine where [primary keys](https://www.techopedia.com/definition/5547/primary-key) coincide with [foreign keys](https://www.techopedia.com/definition/7272/foreign-key). On the other hand, [validations](https://guides.rubyonrails.org/active_record_validations.html) ensure the presence of certain data attributes for an object to pass as valid.

## Create Database Migrations

Migrations manage the changes made to your database schema. To create migrations for the three relations you just modelled, run the following commands:

`rake db:create_migration NAME=faculties`

`rake db:create_migration NAME=departments`

`rake db:create_migration NAME=courses`

These commands create three migration files in a folder "__migrate__" in another folder "__db__". Edit all three files as follows.

```ruby
# 20190719104029_faculties.rb

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

# 20190719104111_departments.rb

class Departments < ActiveRecord::Migration[5.2]
    def up
        create_table :departments do |t|
            t.integer :dept_name
            t.integer :dept_head
            t.integer :dept_email
            t.references :faculty, foreign_key: true
        end
    end
    def down
        drop_table :departments
    end
end

# 20190719104252_courses.rb

class Courses < ActiveRecord::Migration[5.2]
    def up
        create_table :courses do |t|
            t.integer :course_name
            t.integer :course_duration
            t.integer :course_adviser
            t.references :department, foreign_key: true
        end
    end
    def down
        drop_table :courses
    end
end
```

Create a Postgres database, give it a name that matches the name on your database URI path, and run `rake db.migrate`. The command directs ActiveRecord to create three tables in your database according to the specifications on your [migration files](https://edgeguides.rubyonrails.org/active_record_migrations.html). It also auto-generates a new file "__schema.rb__" in the "__db__" folder which is the authoritative origin of the most current state of the database.

## Populate Database

Create a new file ‘seeds.rb’ in the "__db__" folder. It will provide initial records to your empty database tables.

```ruby
# seeds.rb

facultydata = [
    {
        faculty_name: 'Science', 
        faculty_dean: 'Dove Fortune', 
        faculty_email: 'science_faculty@ecollege.com'
    },
    {
        faculty_name: 'Engineering', 
        faculty_dean: 'Krystal Rafe', 
        faculty_email: 'engineering_faculty@ecollege.com'
    },
    {
        faculty_name: 'Medicine', 
        faculty_dean: 'Deryk Tyrell', 
        faculty_email: 'medicine_faculty@college.com'
    },
    {
        faculty_name: 'Arts', 
        faculty_dean: 'Granville Delphia', 
        faculty_email: 'art_faculty@ecollege.com'
    }
]

facultydata.each do |fct|
    Faculty.create(fct)
end
puts 'Faculties table initialized with seed data.'


deptdata = [
    {
        dept_name: 'Chemical Sciences', 
        dept_head: 'Petula Callahan', 
        dept_email: 'chemical_sciences@ecollege.com',
        faculty: Faculty.where(faculty_name: 'Science').first
    },
    {
        dept_name: 'Computer Engineering', 
        dept_head: 'Julie Rothwell', 
        dept_email: 'computer_engineering@ecollege.com',
        faculty: Faculty.where(faculty_name: 'Engineering').first
    },
    {
        dept_name: 'Languages', 
        dept_head: 'Knox Astor', 
        dept_email: 'languages@ecollege.com',
        faculty: Faculty.where(faculty_name: 'Arts').first
    },
    {
        dept_name: 'Medical Sciences', 
        dept_head: 'Norton Gisselle', 
        dept_email: 'med_sciences@ecollege.com',
        faculty: Faculty.where(faculty_name: 'Medicine').first
    }
]

deptdata.each do |dpt|
    Department.create(dpt)
end
puts 'Departments table initialized with seed data'


coursedata = [
    {
        course_name: 'Software Engineering', 
        course_duration: '10 Semesters', 
        course_adviser: 'Danielle Jones',
        department: Department.where(dept_name: 'Computer Engineering').first
    },
    {
        course_name: 'French', 
        course_duration: '8 Semesters', 
        course_adviser: 'Joseph Merkel',
        department: Department.where(dept_name: 'Languages').first
    },
    {
        course_name: 'Industrial Chemistry', 
        course_duration: '8 Semesters', 
        course_adviser: 'Grace Brownson',
        department: Department.where(dept_name: 'Chemical Sciences').first
    },
    {
        course_name: 'Pharmacy', 
        course_duration: '10 Semesters', 
        course_adviser: 'Rylie Phillip',
        department: Department.where(dept_name: 'Medical Sciences').first
    }
]

coursedata.each do |crs|
    Course.create(crs)
end
puts 'Courses table initialized with seed data'
```

## Testing the API

We installed a certain gem called [sinatra-contrib](https://rubygems.org/gems/sinatra-contrib/versions/2.0.4) earlier on. It's role is to give us the capacity to use a namespace for our API endpoints versioning. We previously required "__sinatra/namespace__" in "__app.rb__" to enable the use of a namespace. So in "__app.rb__" add the next snippet of code to test the workability of the API.

```ruby
# app.rb

namespace '/ecollege/api/v1' do
    
    before do
        # Specify a content-type for each code block that comes after it.
        content_type 'application/json'
    end

    get '/' do 
        'This is the official e-college API'
    end 

    after do
        # Close the ActiveRecord connection pool.
        content_type 'application/json'
    end 
end 
```

Start Ruby's WEBrick server by running `shotgun config.ru`. Windows users should run `rackup config.ru` instead. 

Visit http://localhost:9393/ecollege/api/v1/ on your browser if you made your command with "__shotgun__", and http://localhost:9292/ecollege/api/v1/ if you used "__rackup__". This is because each gem defaults to a particular port as is obvious in both URLs.

You should see "__This is the official e-College API__" in your browser if your code is error-free.

## Create endpoints for HTTP GET requests

Append this next block of code right after the first block that contains the root endpoint `get '/' do` in "__app.rb__".

```ruby
get '/faculties' do 
    #Request to retrieve all faculties
    faculties = Faculty.all
    faculties.to_json(include: :departments)
end 

get '/departments' do 
    #Request to retrieve all departments
    departments = Department.all
    departments.to_json(include: :coursess)
end 

get '/courses' do 
    #Request to retrieve all courses
    courses = Course.all
    courses.to_json
end 
```

When you visit this URL http://localhost:9393/ecollege/api/v1/faculties on your browser, you should see this output.

```json
[
    {
        "id": 1,
        "faculty_name": "Science",
        "faculty_dean": "Dove Fortune",
        "faculty_email": "science_faculty@ecollege.com",
        "departments": [
            {
                "id": 1,
                "dept_name": "Chemical Sciences",
                "dept_head": "Petula Callahan",
                "dept_email": "chemical_sciences@ecollege.com",
                "faculty_id": 1
            }
        ]
    },
    {
        "id": 2,
        "faculty_name": "Engineering",
        "faculty_dean": "Krystal Rafe",
        "faculty_email": "engineering_faculty@ecollege.com",
        "departments": [
            {
                "id": 2,
                "dept_name": "Computer Engineering",
                "dept_head": "Julie Rothwell",
                "dept_email": "computer_engineering.ecollege.com",
                "faculty_id": 2
            }
        ]
    },
    {
        "id": 3,
        "faculty_name": "Medicine",
        "faculty_dean": "Deryk Tyrell",
        "faculty_email": "medicine_faculty@college.com",
        "departments": [
            {
                "id": 4,
                "dept_name": "Medical Sciences",
                "dept_head": "Norton Gisselle",
                "dept_email": "med_sciences@ecollege.com",
                "faculty_id": 3
            }
        ]
    },
    {
        "id": 4,
        "faculty_name": "Arts",
        "faculty_dean": "Granville Delphia",
        "faculty_email": "art_faculty@ecollege.com",
        "departments": [
            {
                "id": 3,
                "dept_name": "Languages",
                "dept_head": "Knox Astor",
                "dept_email": "languages@ecollege.com",
                "faculty_id": 4
            }
        ]
    }
]
```

Change the URL to http://localhost:9393/ecollege/api/v1/departments and then to http://localhost:9393/ecollege/api/v1/courses to see their respective outcomes.

## Create endpoints for HTTP GET requests by ID

```ruby
get '/faculties/:id' do |id|
    #Requests a single faculty
    faculty = Faculty.where(id: id).first
    unless faculty
        halt 404, {message: 'Resource not Found'}.to_json
    else
        faculty.to_json(include: :departments)
    end
end

get '/departments/:id' do |id|
    #Requests a single department
    department = Department.where(id: id).first
    unless department
        halt 404, {message: 'Resource not Found'}.to_json
    else
        department.to_json(include: :courses)
    end
end  

get '/courses/:id' do |id|
    #Requests a single course
    course = Course.where(id: id).first
    unless course
        halt 404, {message: 'Resource not Found'}.to_json
    else
        course.to_json
    end
end  
```

Test the endpoint at http://localhost:9393/ecollege/api/v1/faculties/4, and you should see this:

```json
{
    "id": 4,
    "faculty_name": "Arts",
    "faculty_dean": "Granville Delphia",
    "faculty_email": "art_faculty@ecollege.com",
    "departments": [
        {
            "id": 3,
            "dept_name": "Languages",
            "dept_head": "Knox Astor",
            "dept_email": "languages@ecollege.com",
            "faculty_id": 4
        }
    ]
}
```

## Create endpoints for POST requests

You need more than just the browser to make HTTP requests that alter the server resource. Methods such as POST, PUT, and DELETE all make certain changes to the resource. So to make requests to any further endpoints, you need to make [curl](https://curl.haxx.se/) requests. Read on [how to make a post request](https://www.toolsqa.com/postman/post-request-in-postman/) with [Postman](https://assist-software.net/downloads/postman-http-client-testing-web-services) if you are unable to use curl.

```ruby
post '/faculties' do
    #Requests to create a new resource in faculties
    payload = JSON.parse(request.body.read)
    if !payload
        halt 422, {message: 'Inoperable Request'}.to_json
    else
        Faculty.new(payload).save
        {message: 'Resource Create'}.to_json
    end
end

post '/departments' do
    #Requests to create a new resource in departments
    payload = JSON.parse(request.body.read)
    if !payload
        halt 422, {message: 'Inoperable Request'}.to_json
    else
        Department.new(payload).save
        {message: 'Resource Created'}.to_json
    end
end

post '/courses' do
    #Requests to create a new resource in courses
    payload = JSON.parse(request.body.read)
    if !payload
        halt 422, {message: 'Inoperable Request'}.to_json
    else
        Course.new(payload).save
        {message: 'Resource Created'}.to_json
    end
end
```

All the endpoints for making POST requests are basically the same. So open a terminal, navigate to your project directory, and run the commands below.

```
curl -i -X POST -H "Content-Type: application/json" -d'{"faculty_name":"Management", "faculty_dean":"Richard Conrad", "faculty_email":"management_faculty@ecollege.com"}' http://localhost:9393/ecollege/api/v1/faculties

```

You will get the output... `{"message":"Resource Created"}`

## Create endpoints for PUT requests

This HTTP request sends data to the server to update the resource with a given ID. It can send a single resource item as well as the entire resource items to update the original resource.

```ruby
put '/faculties/:id' do |id|
    #Requests to update Faculty resource with new data
    faculty = Faculty.where(id: id).first
    payload = JSON.parse(request.body.read)
    if !faculty
        halt 404, {message: 'Resource not Found'}.to_json
    elsif payload
        faculty.update_attributes(payload).to_json
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
        halt 404, {message: 'Resource not Found'}.to_json
    elsif payload
        department.update_attributes(data).to_json
        {message: 'Resource Update'}.to_json
    else
        halt 422, {message: 'Inoperable Request'}.to_json
    end
end  

put '/courses/:id' do |id|
    #Requests to update Course resource with new data
    course = Course.where(id: id).first
    payload = JSON.parse(request.body.read)
    if !course
        halt 404, {message: 'Resource not Found'}.to_json
    elsif payload
        course.update_attributes(data).to_json
        {message: 'Resource Updated'}.to_json
    else
         halt 422, {message: 'Inoperable Request'}.to_json
    end
end  
```

Run the curl request below to update a single resource item on "__Faculties__" table.

```
curl -i -X PUT -H "Content-Type: application/json" -d'{"faculty_dean":"Richard Conrad"}' http://localhost:9393/ecollege/api/v1/faculties/4
```
This updates the faculties record with __ID 4__ and returns the output... `{"message":"Resource Updated"}`.

## Create endpoints for DELETE requests

When you request to delete an object from a table that has dependent resources, it will delete every associated relation.

```ruby
delete '/faculties/:id' do |id|
    #Request to delete a single faculty
    faculty = Faculty.where(id: id).first
    if faculty
        faculty.destroy
        {message: 'Resource not Found'}.to_json
    else
        halt 500, {message: 'Server Error'}.to_json
    end
end  

delete '/departments/:id' do |id|
    #Request to delete a single faculty
    department = Department.where(id: id).first
    if department
        department.destroy
        {message: 'Resource not Found'}.to_json
    else
        halt 500, {message: 'Server Error'}.to_json
    end
end  

delete '/courses/:id' do |id|
    #Request to delete a single faculty
    course = Course.where(id: id).first
    if course
        course.destroy
        {message: 'Resource not Found'}.to_json
    else
        halt 500, {message: 'Server Error'}.to_json
    end
end 
```

Delete a faculties record with __ID 1__ from the resource by running the curl command below.

```
curl -i -X DELETE -H "Content-Type:application/json"http://localhost:9292/ecollege/api/v1/faculties/1
```

If the request goes through successfully, the output will be... `{"message":"Resource Deleted"}`

## Wrapping it up

There is still so much that needs to be done on the API to make it better, such as implementing validation checks, eliminating repeated code blocks, and deploying it to Heroku. You can get the full project setup on [github](https://github.com/annessca/ecollegeapi). 


## A quick installation
Make sure you have Ruby installed on your local system. If not, you can download it from [this website](https://www.ruby-lang.org/en/downloads/).

You should also have git installed on your local computer. Download git from [git-scm.com](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).


To clone the repository to your local setup, open your bash/terminal, copy and paste each of the following code, and press enter.

`gem install bundler`

`git clone https://github.com/annessca/ecollegeapi.git`

`cd ecollegeapi`

`bundle install`

Take a break from the terminal and create a PostgreSQL database named **ecollege**

`rake db:migrate`

`rake db:seed`

You can also get the tutorial on [Lixy](http://www.lixy.tech/blog) official website.


