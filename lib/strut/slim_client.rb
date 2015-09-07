require "rubygems"
require "rubyslim/ruby_slim"

module Strut
  class SlimClient
    attr_reader :host, :port

    def initialize(host, port)
      @host = host
      @port = port
    end

    def responses_for_commands(commands)
      socket = prepare_socket
      encoded_commands = encode_commands(commands)
      write_commands(socket, encoded_commands)
      response = read_response(socket)
      decode_response(response)
    end

    def prepare_socket
      socket = TCPSocket.open(@host, @port)
      _version = socket.gets  # Read and ignore the Slim version number from the server.
      socket
    end

    def encode_commands(commands)
      serialised_commands = ListSerializer.serialize(commands)
      length = ListSerializer.length_string(serialised_commands.length)
      "#{length}#{serialised_commands}"
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
