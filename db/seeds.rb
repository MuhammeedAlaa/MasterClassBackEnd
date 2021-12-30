# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user_auth = UserAuth.create!(email: 'muhammad.ahmed99@eng-st.cu.edu.eg', password: 'password', password_confirmation: 'password', user_name: 'Alaa', role: 'admin')
Admin.create!(first_name: 'Muhammad', last_name: 'Alaa', birthday: Time.now - 22.years, user_auth_id: user_auth.id)

instructor = UserAuth.create!(email: 'muhammad.hesham99@eng-st.cu.edu.eg', password: 'password', password_confirmation: 'password', user_name: 'Etsh', role: 'instructor')  
Instructor.create!(first_name: 'Muhammad', last_name: 'Ahmed Hisham', birthday: Time.now - 22.years, user_auth_id: instructor.id)

user_auth = UserAuth.create!(email: 'muhmoud.amr99@eng-st.cu.edu.eg', password: 'password', password_confirmation: 'password', user_name: 'Goudy', role: 'learner')
Learner.create!(first_name: 'Muhamoud', last_name: 'Amr', birthday: Time.now - 22.years, user_auth_id: user_auth.id)

user_auth = UserAuth.create!(email: 'houssam.alaa99@eng-st.cu.edu.eg', password: 'password', password_confirmation: 'password', user_name: 'Houso', role: 'learner')
Learner.create!(first_name: 'Housam', last_name: 'Alaa', birthday: Time.now - 22.years, user_auth_id: user_auth.id)
 
course = Course.create!(name: 'Consultation', user_auth: instructor, about: 'this course to understand the basic concepts of conultation and security')
thread = Comment.create!(user_auth: user_auth, course: course, parent_id: nil, body: "This Course is intersting")
Comment.create!(user_auth: user_auth, course: course, parent_id: thread.id, body: "I relly enjoy it!")

course = Course.create!(name: 'Math', user_auth: instructor, about: 'this course to understand the basic concepts of math and calculas 1')
thread = Comment.create!(user_auth: user_auth, course: course, parent_id: nil, body: "This Course is intersting")
Comment.create!(user_auth: user_auth, course: course, parent_id: thread.id, body: "I relly enjoy it!")

course = Course.create!(name: 'Math2', user_auth: instructor, about: 'this course to understand the basic concepts of math and calculas 2')
thread = Comment.create!(user_auth: user_auth, course: course, parent_id: nil, body: "This Course is intersting")
Comment.create!(user_auth: user_auth, course: course, parent_id: thread.id, body: "I relly enjoy it!")

course = Course.create!(name: 'Networks', user_auth: instructor, about: 'this course to understand the basic concepts of networks')
thread = Comment.create!(user_auth: user_auth, course: course, parent_id: nil, body: "This Course is intersting")
Comment.create!(user_auth: user_auth, course: course, parent_id: thread.id, body: "I relly enjoy it!")

course = Course.create!(name: 'Embedded', user_auth: instructor, about: 'this course to understand the basic concepts of embedded systems')
thread = Comment.create!(user_auth: user_auth, course: course, parent_id: nil, body: "This Course is intersting")
Comment.create!(user_auth: user_auth, course: course, parent_id: thread.id, body: "I relly enjoy it!")

course = Course.create!(name: 'Pattarns', user_auth: instructor, about: 'this course to understand the basic concepts of pattarn')
thread = Comment.create!(user_auth: user_auth, course: course, parent_id: nil, body: "This Course is intersting")
Comment.create!(user_auth: user_auth, course: course, parent_id: thread.id, body: "I relly enjoy it!")

course = Course.create!(name: 'ADB', user_auth: instructor, about: 'this course to understand the basic concepts of advanced databases')
thread = Comment.create!(user_auth: user_auth, course: course, parent_id: nil, body: "This Course is intersting")
Comment.create!(user_auth: user_auth, course: course, parent_id: thread.id, body: "I relly enjoy it!")

course = Course.create!(name: 'Modling', user_auth: instructor, about: 'this course to understand the basic concepts of modling')
thread = Comment.create!(user_auth: user_auth, course: course, parent_id: nil, body: "This Course is intersting")
Comment.create!(user_auth: user_auth, course: course, parent_id: thread.id, body: "I relly enjoy it!")
