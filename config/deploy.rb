set :application, "telstra"
set :repository, "https://github.com/somu45/myapp.git"
set :domain, '154.8.5.68' #Your Accelerators public IP address
set :stage, :production
set :branch, 'master'

set :scm, :git
                              # Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :deploy_to, "/home/projects/"
set :user, "root"

set :keep_releases, 5
set :log_level, :debug

# role :web, domain # Your HTTP server, Apache/etc
# role :app, domain # This may be the same as your `Web` server
# role :db, domain, :primary => true # This is where Rails migrations will run

server '154.8.5.68', user: 'root', roles: %w{web app db} #app1

set :password, ask('Server password:', nil)
 set :ssh_options, {
 	verbose: :debug,
    user: "root",
    forward_agent: true,
    keys: %w(~/.ssh/id_rsa.pub),
    auth_methods: %w(publickey password),
    password: fetch(:password)
 }
# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :parallel, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
end 

