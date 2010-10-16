require File.expand_path(File.dirname(__FILE__) + '/pid_file')

class RailsServer

  PID_FILE = 'tmp/pids/server.pid'
  SERVER_SCRIPT = 'script/server'

  def self.start
    ENV['RAILS_ENV'] ||= 'test'
    unless PidFile.new(PID_FILE).running?
      system "#{SERVER_SCRIPT} -d -e #{ENV['RAILS_ENV']}"
    else
      puts "server:start: Pidfile #{PID_FILE} already exists, will not start a new server."
    end
  end

  def self.stop
    if PidFile.new(PID_FILE).running?
      system "kill -INT `cat #{PID_FILE}`"
      puts "server:stop: Stopping server from pidfile #{PID_FILE}."
    else
      puts "server:stop: Pidfile #{PID_FILE} does not exist, not stopping server."
    end 
  end
end
