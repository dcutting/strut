require "rubygems"
require "rubyslim/ruby_slim"

module Strut
  class SlimClient
    def initialize(host, port, max_attempts)
      @host = host
      @port = port
      @max_attempts = max_attempts
    end

    def responses_for_commands(commands)
      encoded_commands = encode_commands(commands)
      socket = prepare_socket
      read_and_ignore_version(socket)
      write_commands(socket, encoded_commands)
      response = read_response(socket)
      decode_response(response)
    end

    def encode_commands(commands)
      flattened_commands = commands.map { |c| c.to_a }
      serialised_commands = ListSerializer.serialize(flattened_commands)
      length = ListSerializer.length_string(serialised_commands.length)
      "#{length}#{serialised_commands}"
    end

    def prepare_socket
      socket = nil
      attempts = 0
      while socket.nil? and attempts < @max_attempts do
        begin
          socket = TCPSocket.open(@host, @port)
        rescue
          attempts += 1
          sleep(2)
        end
      end
      throw "Could not connect to Slim server." if socket.nil?
      socket
    end

    def read_and_ignore_version(socket)
      socket.gets
    end

    def write_commands(socket, commands)
      socket.puts(commands)
    end

    def read_response(socket)
      length = socket.read(6).to_i  # <length>
      socket.read(1)                # :
      socket.read(length)           # <command>
    end

    def decode_response(response)
      ListDeserializer.deserialize(response)
    end
  end
end
