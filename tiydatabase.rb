require 'sinatra'
require 'pg'
require 'awesome_print'

require 'sinatra/reloader' if development?

get '/' do
  erb :home
end

get '/employees' do
  database = PG.connect(dbname: "tiy-database")
  @people = database.exec("select * from employees")
  ap @people
  erb :employees
end

get '/employee' do
  which_employee = params["name"]

  database = PG.connect(dbname: "tiy-database")
  @people = database.exec("SELECT * FROM employees WHERE name = $1", [which_employee])

  erb :employee
end

get '/new_employee' do
  erb :new_employee
end

get '/create_employee' do
  name = params["name"]
  phone = params["phone"]
  address = params["address"]
  position = params["position"]
  salary = params["salary"]
  github = params["github"]
  slack = params["slack"]

  database = PG.connect(dbname: "tiy-database")

  @people = database.exec("INSERT INTO employees(name, phone, address, position, salary, github, slack) VALUES($1, $2, $3, $4, $5, $6, $7)", [name, phone, address, position, salary, github, slack])

  redirect to("/employees")
end

get '/search_employee' do
  erb :search_employee
end

get '/search_results' do
  which_employee = params["search_param"]

  database = PG.connect(dbname: "tiy-database")

  @people = database.exec("SELECT * FROM employees WHERE name = $1 OR github = $1 OR slack = $1 OR name LIKE $1", ["%#{which_employee}%"])

  erb :employee
end

get '/edit_employee' do
  id = params["id"]

  database = PG.connect(dbname: "tiy-database")
  people = database.exec("SELECT * FROM employees WHERE id = $1", [id])

  @person = people.first

  erb :edit_employee
end

get '/update_employee' do
  name = params["name"]
  phone = params["phone"]
  address = params["address"]
  position = params["position"]
  salary = params["salary"]
  github = params["github"]
  slack = params["slack"]
  id = params["id"]

  database = PG.connect(dbname: "tiy-database")

  @people = database.exec("UPDATE employees SET name = $1, phone = $2, address = $3, position = $4, salary = $5, github = $6, slack = $7 WHERE id = $8", [name, phone, address, position, salary, github, slack, id])

  redirect to("/employees")
end

get '/delete_employee' do
  id = params["id"]

  database = PG.connect(dbname: "tiy-database")

  @people = database.exec("DELETE FROM employees WHERE id = $1", [id])

  redirect to("/employees")
end

get '/courses' do
  database = PG.connect(dbname: "tiy-database")
  @all_courses = database.exec("select * from courses")

  erb :courses
end

get '/course' do
  which_course = params["course_name"]

  database = PG.connect(dbname: "tiy-database")
  @all_courses = database.exec("SELECT * FROM courses WHERE course_name = $1", [which_course])

  erb :course
end

get '/new_course' do
  erb :new_course
end

get '/create_course' do
  course_name = params["course_name"]
  course_subject = params["course_subject"]
  course_cost = params["course_cost"]
  course_length = params["course_length"]

  database = PG.connect(dbname: "tiy-database")

  @all_courses = database.exec("INSERT INTO courses(course_name, course_subject, course_cost, course_length) VALUES($1, $2, $3, $4)", [course_name, course_subject, course_cost, course_length])

  redirect to("/courses")
end

get '/search_course' do
  erb :search_course
end

get '/search_course_results' do
  which_course = params["search_param"]

  database = PG.connect(dbname: "tiy-database")
  @all_courses = database.exec("SELECT * FROM courses WHERE course_name = $1 OR course_name LIKE $1", ["%#{which_course}%"])

  erb :course
end

get '/edit_course' do
  id = params["id"]

  database = PG.connect(dbname: "tiy-database")
  courses = database.exec("SELECT * FROM courses WHERE id = $1", [id])

  @course = courses.first

  erb :edit_course
end

get '/update_course' do
  course_name = params["course_name"]
  course_subject = params["course_subject"]
  course_cost = params["course_cost"]
  course_length = params["course_length"]
  id = params["id"]

  database = PG.connect(dbname: "tiy-database")

  @all_courses = database.exec("UPDATE courses SET course_name = $1, course_subject = $2, course_cost = $3, course_length = $4 WHERE id = $5", [course_name, course_subject, course_cost, course_length, id])

  redirect to("/courses")
end

get '/delete_course' do
  id = params["id"]

  database = PG.connect(dbname: "tiy-database")

  @all_courses = database.exec("DELETE FROM courses WHERE id = $1", [id])

  redirect to("/courses")
end
