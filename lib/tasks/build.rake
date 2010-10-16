namespace :server do
  desc "Starts the rails server if it is not already running"
  task :start do
    require 'rails_server'
    RailsServer.start
    sleep 1
  end

  desc "Stops the rails server"
  task :stop do
    require 'rails_server'
    RailsServer.stop
  end

  desc "Restarts the rails server"
  task :restart => ["server:stop", "server:start"]
end

