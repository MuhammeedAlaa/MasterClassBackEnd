json.success 'success'
json.data do
  json.courses @courses
end
json.limit @limit
json.offset @offset
json.page @page
json.count @count
json.total @total
