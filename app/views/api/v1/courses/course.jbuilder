json.success 'success'
json.data do
  json.extract! @course, :name, :id, :about
  json.course_image @course_image
  json.instructor_user_name @instructor_user_name
  json.instructor_image  @instructor_image
end