set :repository,  "git://github.com/ttencate/blimp.git"
set :branch,      "origin/master"
set :deploy_to,   "/var/www/blimp"
set :current_path,"#{deploy_to}/current"
set :shared_path, "#{deploy_to}/shared"
set :user,        "blimp"
set :use_sudo,    false

set :shared_symlinks, { } 

role :web, "blimp.martenveldthuis.com"                          # Your HTTP server, Apache/etc
role :app, "blimp.martenveldthuis.com"                          # This may be the same as your `Web` server
role :db,  "blimp.martenveldthuis.com", :primary => true        # This is where Rails migrations will run
