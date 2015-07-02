require 'rubygems'
require 'chef'
require 'chef/user'
require 'chef/config'
require 'chef/log'
require 'chef/rest'

chef_server_url="https://aserver"
client_name = "pivotal"
signing_key_filename="/vagrant/pivotal.pem"
key_content = File.read(signing_key_filename)

rest = Chef::REST.new(chef_server_url, client_name, nil, :raw_key => key_content)

begin 

# Organizations list
puts "\n* Listing organizations: "
puts orgs = rest.get_rest("/organizations")

# Create organization
if not orgs['frabs']
  puts "\n* Creating organization: "
  puts org = rest.post(
    '/organizations', 
    { name: "frabs", full_name: "Frabs, Org."}
  )
  puts "Response type: #{org.class}"
  puts "Response keys: #{org.keys}"
  orgs = rest.get_rest("/organizations")
end

# Get organization
puts "\n* Getting a single organization: "
puts rest.get("/organizations/frabs")

puts "\n* Get a non-existing node: "
begin
  puts rest.get('/organizations/frabs/nodes/mynode') 
rescue => ex
  puts ex.class
  puts ex.response.code
  puts ex.response.code.class
  puts ex.response.message
  puts ex.to_s
end

# Get user details
# puts "\n* Getting user details: "
# puts rest.get("/users/admin")

# Users list
puts "\n* Listing users: "
puts users = rest.get_rest("/users")

# Create user
if not users['mafraba']
  puts "\n* Creating user: "
  puts mafraba = rest.post(
    '/users', 
    { 
      name: "mafraba",
      display_name: 'Manuel Franco',
      email: 'mafraba@gmail.com',
      # admin: true,
      password: 'Saluda.123'
    }
  )
  # user = Chef::User.new
  # user.name('mafraba')
  # user.admin(true)
  # user.password 'Saluda.123'
  # user.create

  File.open('mafraba.pem', 'w') {|f| f.write(mafraba['private_key']) }

  # Users list
  puts "\n* Listing users: "
  puts users = rest.get_rest("/users")
end

puts "\n* Listing users for organization: "
puts org_users = rest.get('/organizations/frabs/users')

puts "\n* Adding user for organization: "
puts rest.post('/organizations/frabs/users', username: "mafraba") rescue puts "bug in chef rest client ??"
puts rest.post('/organizations/frabs/users', username: "admin") rescue puts "bug in chef rest client ??"

puts "\n* Listing users for organization: "
puts org_users = rest.get('/organizations/frabs/users')
puts "Response type: #{org_users.class}"

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


# puts "\n* Checking new admin permissions by creating client:"
# orest = Chef::REST.new(chef_server_url, 'mafraba', nil, :raw_key => mafraba['private_key'])
# puts api_cli = orest.post(
#     '/organizations/frabs/clients', 
#     { 
#       name: "apicli",
#       admin: true
#     }
#   )

# puts "\n* Listing clients for organization: "
# puts orest.get('/organizations/frabs/clients')

# puts "\n* Testing #{org['clientname']} permission to create another client: "
# orest = Chef::REST.new(chef_server_url, org['clientname'], nil, :raw_key => org['private_key'])
# puts second_cli = orest.post(
#     '/organizations/frabs/clients', 
#     { 
#       name: "secondcli",
#       admin: false
#     }
#   )

puts "\n* Creating node:"
orest = Chef::REST.new(chef_server_url, 'mafraba', nil, :raw_key => mafraba['private_key'])
puts api_cli = orest.post(
    '/organizations/frabs/nodes', 
    # { 
    #   name: "apicli"
    # }
    {"name"=>"5594039e2550d11f9100002a", "run_list"=>[]}
  )

rescue => ex

puts ex

################### CLEAN UP ###########################
ensure

# Delete user
puts "\n* Deleting users: "
users.keys.reject{|u| u == 'pivotal'}.each do |user|
  puts rest.delete("/users/#{user}")
end


# Delete organization
puts "\n* Deleting organizations: "
orgs.keys.each do |orgn|
  puts rest.delete("/organizations/#{orgn}")
end

end