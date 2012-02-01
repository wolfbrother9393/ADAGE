$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.3'

require 'bundler/capistrano'
load 'deploy/assets'

set :application, "ada"

set :stages, %w(production staging)
set :default_stage, "staging"

set :scm, :git
set :repository,  "git@github.com:wids-eria/ada.git"
set :branch, "master"

role :web, "terrordome.discovery.wisc.edu"
role :app, "terrordome.discovery.wisc.edu"
role :db,  "terrordome.discovery.wisc.edu", :primary => true # This is where Rails migrations will run

set :user, :deploy
ssh_options[:forward_agent] = true
set :deploy_to, "/var/www/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :normalize_asset_timestamps, false

# CALLBACKS #########

after 'deploy:finalize_update', 'deploy:symlink_db'

set :passenger_port, 9292
def passenger_cmd(environment)
  "RAILS_ENV=#{environment} bundle exec passenger"
end

namespace :deploy do
  desc "Symlinks the database.yml"
  task :symlink_db, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{deploy_to}/shared/config/mongoid.yml #{release_path}/config/mongoid.yml"
  end

  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && #{passenger_cmd(rails_env)} start -e #{rails_env} -p #{passenger_port} -d"
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && #{passenger_cmd(rails_env)} stop -p #{passenger_port}"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run <<-CMD
      if [[ -f #{current_path}/tmp/pids/passenger.#{passenger_port}.pid ]];
      then
        cd #{current_path} && #{passenger_cmd(rails_env)} stop -p #{passenger_port};
      fi
    CMD

    run "cd #{current_path} && #{passenger_cmd(rails_env)} start -e #{rails_env} -p #{passenger_port} -d"
  end
end