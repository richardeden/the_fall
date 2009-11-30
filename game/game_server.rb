require 'rubygems'
require 'active_support'
require 'active_record'
require 'json'
require 'yaml'

require File.join(File.dirname(__FILE__), 'server')

RAILS_ROOT = File.join(File.dirname(__FILE__), '..')

ActiveSupport::Dependencies.load_paths << File.join(File.dirname(__FILE__), '..', 'app', 'models')

dbconfig = YAML::load(File.open(File.join(RAILS_ROOT, 'config', 'database.yml')))
ActiveRecord::Base.establish_connection(dbconfig['development'])

class GameServer < Server
  attr :connections
  
  POLICY_REQUEST = "<policy-file-request/>"

  POLICY_FILE = <<-EOF
    <cross-domain-policy>
    <allow-access-from domain="*" to-ports="PORT" />
    </cross-domain-policy>
  EOF
  

  def send_cmd(cmds, options={})
    log 'outgoing broadcast: ' + cmds.inspect
    connections.each do |client|
      next if options[:except] == client
      client.send_cmd cmds
    end
  end

  def command(con, data)
    data.split("\0").each do |data|
      log "incoming: #{data}"
      if data == POLICY_REQUEST
        con.send_data POLICY_FILE.gsub('PORT', @options[:port].to_s)
        con.close_connection_after_writing
        return
      end
      begin
        data = JSON.parse(data)
      rescue JSON::ParserError
        log 'bad data:' + data.inspect
        return
      end
      if %w{join move attack leave login stats}.include?(data['command'])
        params = data['data'] || {}
        con.send(data['command'], params.symbolize_keys)
      else
        log "Invalid command: #{data['command']}"
      end
    end
  end
  
end