require 'rubygems'
require 'chef/config'
require 'chef/log'
require 'chef/rest'

chef_server_url="https://aserver"
client_name = "pivotal"
signing_key_filename="/vagrant/pivotal.pem"

rest = Chef::REST.new(chef_server_url, client_name, signing_key_filename)

# Organizations list
puts "Listing organizations: "
puts orgs = rest.get_rest("/organizations")

# Create organization
if not orgs['frabs']
  puts "Creating organization: "
  puts rest.post(
    '/organizations', 
    { name: "frabs", full_name: "Frabs, Org."}
  )
end

# Get organization
puts "Getting a single organization: "
puts rest.get("/organizations/frabs")

# Delete organization
puts "Deleting an organization: "
puts rest.delete("/organizations/frabs")

