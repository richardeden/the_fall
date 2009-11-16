Given /^a user called "([^\"]*)"$/ do |name|
  User.create(:username => name, :email => "#{name}@example.com", :password => 'password123', :password_confirmation => 'password123')
end
