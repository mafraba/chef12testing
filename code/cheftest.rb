require 'rubygems'
require 'chef'
require 'chef/user'
require 'chef/config'
require 'chef/log'
require 'chef/rest'

chef_server_url="https://aserver"
client_name = "pivotal"
signing_key_filename="/vagrant/pivotal.pem"

rest = Chef::REST.new(chef_server_url, client_name, signing_key_filename)

# Organizations list
puts "\n* Listing organizations: "
puts orgs = rest.get_rest("/organizations")

# Create organization
if not orgs['frabs']
  puts "\n* Creating organization: "
  puts rest.post(
    '/organizations', 
    { name: "frabs", full_name: "Frabs, Org."}
  )
end

# Get organization
puts "\n* Getting a single organization: "
puts rest.get("/organizations/frabs")


# Get user details
puts "\n* Getting user details: "
puts rest.get("/users/admin")

# Users list
puts "\n* Listing users: "
puts users = rest.get_rest("/users")

# Create user
if not users['mafraba']
  puts "\n* Creating user: "
  puts rest.post(
    '/users', 
    { 
      name: "mafraba",
      display_name: 'Manuel Franco',
      email: 'mafraba@gmail.com',
      admin: true,
      password: 'Saluda.123'
    }
  )
  # user = Chef::User.new
  # user.name('mafraba')
  # user.admin(true)
  # user.password 'Saluda.123'
  # user.create

  # Users list
  puts "\n* Listing users: "
  puts users = rest.get_rest("/users")
end

puts "\n* Listing users for organization: "
puts users = rest.get('/organizations/frabs/users')

puts "\n* Adding user for organization: "
puts rest.post('/organizations/frabs/users', username: "mafraba") rescue puts "bug in chef rest client ??"
puts rest.post('/organizations/frabs/users', username: "admin") rescue puts "bug in chef rest client ??"

puts "\n* Listing admins for organization: "
puts adms = rest.get('/organizations/frabs/groups/admins')

puts "\n* Adding admin for organization: "
adms['users'] << 'mafraba'
adms['actors'] << 'mafraba'
# puts adms
# puts rest.post('/organizations/frabs/users', { username: 'mafraba'})
puts rest.put(
  '/organizations/frabs/groups/admins', 
  { groupname: "admins", actors: {clients: adms['clients'], users: adms['users'], groups: adms['groups']}, orgname: "frabs" }
)

puts "\n* Listing admins for organization: "
puts rest.get('/organizations/frabs/groups/admins')

################### CLEAN UP ###########################

# Delete user
puts "\n* Deleting a user: "
puts rest.delete("/users/mafraba")


# Delete organization
puts "\n* Deleting an organization: "
puts rest.delete("/organizations/frabs")

