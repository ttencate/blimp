require File.join(File.expand_path(File.dirname(__FILE__)), "lib", "blimp")
require Blimp.root.join("environments/#{ENV["RACK_ENV"]}")

run Blimp::WebServer
