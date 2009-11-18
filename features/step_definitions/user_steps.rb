def create_user(name)
  User.create(:username => name, :email => "#{name}@example.com", :password => 'password123', :password_confirmation => 'password123')
end

Given /^a user called "([^\"]*)"$/ do |name|
  create_user(name)
end

Given /^I am logged in as a user called "([^\"]*)"$/ do |name|
  create_user(name)
  When %{I go to the homepage}
  And %{I follow "Login"}
  And %{I fill in "Username" with "JoeBloggs"}
  And %{I fill in "Password" with "password123"}
  And %{I press "Login"}
end

