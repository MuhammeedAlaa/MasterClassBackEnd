json.success "success"
json.data do
  json.user @data
  json.access_token @token
end