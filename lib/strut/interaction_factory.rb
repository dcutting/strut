module Strut
  Interaction = Struct.new(:uri, :method, :statusCode)

  class InteractionFactory
    def make_interaction(path_stack)
      interaction = Interaction.new

      if path_stack[0] == "paths"
        interaction.uri = path_stack[1] unless extension?(path_stack[1])
      end

      interaction.method = path_stack[2] unless extension?(path_stack[2])

      if path_stack[3] == "responses"
        interaction.statusCode = path_stack[4]
      end

      interaction
    end

    def extension?(tag)
       tag =~ /^x-/
    end
  end
end
