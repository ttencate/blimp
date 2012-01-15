set :repository,  "git://github.com/ttencate/blimp.git"
set :branch,      "origin/master"
set :deploy_to,   "/var/www/blimp.martenveldthuis.com"
set :current_path,"#{deploy_to}/current"
set :shared_path, "#{deploy_to}/shared"
set :user,        "blimp"
set :use_sudo,    false

set :shared_symlinks, { } 

role :web, "frozenfractal.com"                          # Your HTTP server, Apache/etc
role :app, "frozenfractal.com"                          # This may be the same as your `Web` server
role :db,  "frozenfractal.com", :primary => true        # This is where Rails migrations will run