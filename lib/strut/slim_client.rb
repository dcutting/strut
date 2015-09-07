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
      serialised_commands = ListSerializer.serialize(commands)

      length = "%06d" % (serialised_commands.length)
      encoded_commands = "#{length}:#{serialised_commands}"

      socket = TCPSocket.open(@host, @port)
      version = socket.gets
      socket.puts(encoded_commands)

      length = socket.read(6).to_i    # <length>
      socket.read(1)                  # :
      response = socket.read(length)  # <command>

      ListDeserializer.deserialize(response)
    end
  end
end
