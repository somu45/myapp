worker_processes 1
APP_DIR = "/home/deploy/myapp"
working_directory APP_DIR + "/current"

#listen "/tmp/sockets/unicorn.sock", :backlog => 64
listen 4567, :tcp_nopush => true

pid APP_DIR + "/current/tmp/pids/unicorn.pid"

stderr_path APP_DIR + "/shared/log/unicorn.stderr.log"
stdout_path APP_DIR + "/shared/log/unicorn.stdout.log"

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
    GC.copy_on_write_friendly = true


before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
end
