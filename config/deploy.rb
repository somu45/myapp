require 'bundler/capistrano'
require 'capistrano-rbenv'
require 'capistrano/ext/multistage'
require 'capistrano/sidekiq'
require 'capistrano-unicorn'

# stages list. Dont muss up with rails environment. Stage is a settings for capistrano deployment.
# you may run any stage with: cap production deploy
set :stages, %w(production)
# default stage that is going to be run by command cap deploy
set :default_stage, "production"

set :rbenv_path, '/usr/local/rbenv'
set :rbenv_ruby_version, '2.1.2'

# if you use rvm set ruby version and rvm gemset
# set :rvm_ruby_string, "ruby-2.1.2@taxipixi"

set :bundle_gemfile, -> { 'Gemfile' }

# some files that are common to all releases. they'll be simlinked to new release from shared folder
set :shared_children, shared_children 

# application name
set :application, "myapp"

# path where capistrano is going to deploy to
set(:deploy_to) { "/home/#{user}/#{application}" }

# deploy with sudo user access rights (not recommended)
set :use_sudo, false

# deploy from remote repository
set :scm, :git
set :repository,  "git@github.com:somu45/myapp.git"
set :deploy_via, :remote_cache

# deply from local repository
#set :scm, :none
#set :repository, "."
#set :deploy_via, :copy


# sidekiq settings
#set(:sidekiq_cmd)     { "bundle exec sidekiq -e #{rails_env} -C #{current_path}/config/setting_files/sidekiq.yml" }
#set(:sidekiqctl_cmd)  { "bundle exec sidekiqctl" }
#set(:sidekiq_timeout) { 10 }
#set(:sidekiq_role)    { :app }
#set(:sidekiq_pid)     { "#{current_path}/tmp/pids/sidekiq.pid" }
#set(:sidekiq_processes) { 1 }


#before 'deploy', 'monit:stop'
#before 'sidekiq:restart', 'monit:stop'

after 'deploy:restart', 'deploy:cleanup'

after 'deploy:restart', 'unicorn:stop'    # app IS NOT preloaded
after 'deploy:restart', 'unicorn:start'   # app preloaded
after 'deploy:restart', 'unicorn:duplicate'


namespace :logs do
  desc "show rails logs in realtime"
  task :realtime, :roles => :app do
    trap("INT") { puts 'Interupted'; exit 0; }
    run "tail -f #{shared_path}/log/unicorn.stdout.log" do |channel, stream, data|
      puts "#{channel[:host]}: #{data}"
      break if stream == :err
    end
  end

  desc "show rails logs"
  task :newest, :roles => :app do
    trap("INT") { puts 'Interupted'; exit 0; }
    run "tail -50 #{shared_path}/log/unicorn.stdout.log"
  end
end
