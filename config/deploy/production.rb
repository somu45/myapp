# capistrano will use this user to perform actions
set :user, "deploy"

# branch that is going to be used to deploy release. You may set it from console: cap deploy -s branch=_branch_name
set :branch, fetch(:branch, "production")

# server ip or domain, with roles.
#server 'ec2-54-76-155-50.eu-west-1.compute.amazonaws.com', :app, :web, :db, :primary => true
server 'localhost', :app, :web, :db, :primary => true
# rails environment that release is going to be run at.
set :rails_env, "production"

# ssh options
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:auth_methods] = ["publickey"]
# it is not wise to store amazon key in repository. You need to get it from instance owner and set path to it here
ssh_options[:keys] = ["/root/.ssh/id_rsa"]

before 'deploy:update', 'unicorn:stop'
# before 'deploy:update', 'sidekiq:stop'
