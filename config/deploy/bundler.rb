require 'bundler/capistrano'

set :current_release, current_path
after "deploy:update", "bundle:install"
