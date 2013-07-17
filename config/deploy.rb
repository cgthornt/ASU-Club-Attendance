set :application, "clubtrack"
set :scm, 'git'
set :repository,  "git@github.com:cgthornt/ASU-Club-Attendance.git"
default_run_options[:pty] = true

set :deploy_to, "/home/christopher/clubtrack"
set :deploy_via, :copy
set :copy_strategy, :export


role :web, "cgthornt.com"                          # Your HTTP server, Apache/etc
role :app, "cgthornt.com"                          # This may be the same as your `Web` server
role :db,  "cgthornt.com", :primary => true       # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end

require "bundler/capistrano"