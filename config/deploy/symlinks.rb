namespace :symlinks do
  desc "Make all the damn symlinks"
  task :make, :roles => :app, :except => { :no_release => true } do
    commands = shared_symlinks.map do |from, to|
      "ln -sf #{shared_path}/#{from} #{current_path}/#{to}"
    end

    run <<-CMD
      cd #{current_path} && #{commands.join(" && ")}
    CMD
  end
end

after "deploy:update", "symlinks:make"
