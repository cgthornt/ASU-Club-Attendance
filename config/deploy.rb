set :application, "clubtrack"
set :scm, 'git'
set :repository,  "git@github.com:cgthornt/ASU-Club-Attendance.git"
default_run_options[:pty] = true

set :deploy_to, "/home/christopher/clubtrack"
set :deploy_via, :copy
set :copy_strategy, :export


set :rvm_type, :system

role :web, "cgthornt.com"                          # Your HTTP server, Apache/etc
role :app, "cgthornt.com"                          # This may be the same as your `Web` server
role :db,  "cgthornt.com", :primary => true       # This is where Rails migrations will run


# Run Migrations
after "deploy:update_code", "deploy:migrate"

# if you want to clean up old releases on each deploy uncomment this:
# safter "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end

   desc "Correctly cleans up old releases"
   task :cleanup, :except => { :no_release => true } do
     count = fetch(:keep_releases, 5).to_i
     run "ls -1dt #{releases_path}/* | tail -n +#{count + 1} | #{sudo} xargs rm -rf"
   end
end

namespace :config do

  task :copy do
    run "cp -R #{shared_path}/config/* #{latest_release}/config/"
  end


end

before 'deploy:restart', 'config:copy'


require "bundler/capistrano"
require "rvm/capistrano"