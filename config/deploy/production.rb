# # server-based syntax
# # ======================
# # Defines a single server with a list of roles and multiple properties.
# # You can define all roles on a single server, or split them:

# server "52.24.181.91", user: "developer", roles: %w{app db web}, primary:true
# # server "example.com", user: "deploy", roles: %w{app web}, other_property: :other_value
# # server "db.example.com", user: "deploy", roles: %w{db}
# set :rails_env, :production
# set :stage, :production
# # role-based syntax
# # ==================

# # Defines a role with one or multiple servers. The primary server in each
# # group is considered to be the first unless any hosts have the primary
# # property set. Specify the username and a domain or IP for the server.
# # Don't use `:all`, it's a meta role.

# role :app, %w{developer@52.24.181.91}
# role :web, %w{developer@52.24.181.91}
# role :db,  %w{developer@52.24.181.91}



# # Configuration
# # =============
#  # These variables are then only loaded and set in this stage.
# # For available Capistrano configuration variables see the documentation page.
# # http://capistranorb.com/documentation/getting-started/configuration/
# # Feel free to add new variables to customise your setup.



# # Custom SSH Options
# # ==================
# # You may pass any option but keep in mind that net/ssh understands a
# # limited set of options, consult the Net::SSH documentation.
# # http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
# #
# # Global options
# # --------------
#  set :ssh_options, {
#    keys: %w(/home/nosov/.ssh/id_rsa),
#    forward_agent: true,
#    auth_methods: %w(publickey password),
#    port: 4321
#  }
# #


set :port, 4321
set :user, 'developer'
set :deploy_via, :remote_cache
set :use_sudo, false

server '52.24.181.91',
  roles: [:web, :app, :db],
  port: fetch(:port),
  user: fetch(:user),
  primary: true

set :deploy_to, '/home/developer/qa'

set :ssh_options, {
  forward_agent: true,
  auth_methods: %w(publickey),
  user: 'developer',
}

set :rails_env, :production
set :conditionally_migrate, true
