json.success "success"
json.data do
  json.user @data
  json.access_tokn @user_auth.generate_jwt
end