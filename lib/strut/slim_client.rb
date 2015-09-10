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
      encoded_commands = encode_commands(commands)
      socket = prepare_socket
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
      socket = TCPSocket.open(@host, @port)
      read_and_ignore_version(socket)
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
