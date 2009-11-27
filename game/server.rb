require 'rubygems'
require 'eventmachine'

require File.join(File.dirname(__FILE__), 'connection')

class Server
  def initialize(options)
    @options = options
    @connections = []
  end
  
  def disconnect(connection)
    @connections.delete(connection)
    puts "disconnected"
  end
  
  def run
    EventMachine::run do
      EventMachine::start_server '0.0.0.0', @options[:port], Connection do |connection|
        add_connection(connection)
      end
      puts "Listening on #{@options[:port]}"
    end
  end
  
  private
  
  def add_connection(connection)
    connection.server = self
    @connections << connection
    puts 'connect'
  end
  
end

