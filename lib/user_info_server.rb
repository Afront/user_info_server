# require "user_info_server/version"
# require 'sinatra/base'
  
# module UserInfoServer
#   class Error < StandardError; end

#   class App < Sinatra::Base
#   #  class Error < StandardError; end

#     set :app_file, caller_files.first || $0
#     set :sessions, true
#     set :foo, 'bar'
#     set :start, Proc.new { $0 == app_file }
#     set :public_folder, 'public'

#     get '/' do
#       redirect '/index.html'
#     #      File.read 'index.html'
#     end

# #    get '/'
#   end

#   at_exit { App.start! if $!.nil? && App.start? }
# end

require "user_info_server/version"
require 'json'
require 'socket'

module UserInfoServer
  class Error < StandardError; end

  class Request
    attr_accessor :username, :number, :colour

    def initialize(username:, number:, colour:)
      @username = username
      @number = number
      @colour = colour
    end

    def self.from_hash(hash)
      Request.new(username: hash['username'], number: hash['number'], colour: hash['colour'])
    end
  end

  class Server
    attr_accessor :address, :port

    def initialize(address: 'localhost', port: '31415')
      @address = address
      @port = port    
    end

    def process(request)
      # ...
    end

    def save_to_db(request)
      # ...      
    end

    def decode_request(request)
      decoded_request = JSON.parse(request)
      Request.from_hash(decoded_request)
    rescue JSON::ParserError => e
    end

    def handle_request
      msg, addr = @server.recvfrom(1024) 

      request = decode_request(msg)
      save_to_db request
      process request
      puts request
      @server.send(msg, 0, addr[3], addr[1])      
    end

    def run
      @server = UDPSocket.new
      @server.bind('localhost', 31415)

      while true
        handle_request
      end
    end
  end

  server = Server.new
  server.run
end
