module Strut
  Interaction = Struct.new(:uri, :method, :statusCode)

  class InteractionFactory
    def make_interaction(path_stack)
      interaction = Interaction.new
      if path_stack[0] == "paths"
        interaction.uri = path_stack[1]
      end
      if path_stack[2] !~ /^x-/
        interaction.method = path_stack[2]
      end
      if path_stack[3] == "responses"
        interaction.statusCode = path_stack[4]
      end
      interaction
    end
  end
end
