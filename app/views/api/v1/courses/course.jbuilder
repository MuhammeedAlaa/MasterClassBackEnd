json.success 'success'
json.data do
  json.extract! @course, :name, :id
end