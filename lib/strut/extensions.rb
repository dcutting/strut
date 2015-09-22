require "psych"

# Adapted from:
# http://stackoverflow.com/questions/29462856/loading-yaml-with-line-number-for-each-key

module Psych
  def self.parse_yaml(yaml)
    handler = LineNumberHandler.new
    parser =  Psych::Parser.new(handler)
    handler.parser = parser
    parser.parse(yaml)
    handler.root.to_ruby.first
  end
end

# Psych's first step is to parse the Yaml into an AST of Node objects
# so we open the Node class and add a way to track the line.
class Psych::Nodes::Node
  attr_accessor :line
end

# We need to provide a handler that will add the line to the node
# as it is parsed. TreeBuilder is the "usual" handler, that
# creates the AST.
class LineNumberHandler < Psych::TreeBuilder

  # The handler needs access to the parser in order to call mark
  attr_accessor :parser

  # We are only interested in scalars, so here we override
  # the method so that it calls mark and adds the line info
  # to the node.
  def scalar value, anchor, tag, plain, quoted, style
    mark = parser.mark
    s = super
    s.line = mark.line
    s
  end

  def start_mapping anchor, tag, implicit, style
    mark = parser.mark
    s = super
    s.line = mark.line
    s
  end

  def start_sequence anchor, tag, implicit, style
    mark = parser.mark
    s = super
    s.line = mark.line
    s
  end
end

# The next step is to convert the AST to a Ruby object.
# Psych does this using the visitor pattern with the ToRuby
# visitor. Here we patch ToRuby rather than inherit from it
# as it makes the last step a little easier.
class Psych::Visitors::ToRuby

  # This is the method for creating hashes. There may be problems
  # with Yaml mappings that have tags.
  def revive_hash hash, o
    o.children.each_slice(2) { |k,v|
      key = accept(k)
      val = accept(v)

      val = { "value" => val, "line" => v.line} # line is 0 based, so + 1

      # Code dealing with << (for merging hashes) omitted.
      # If you need this you will probably need to copy it
      # in here. See the method:
      # https://github.com/tenderlove/psych/blob/v2.0.13/lib/psych/visitors/to_ruby.rb#L333-L365

      hash[key] = val
    }
    hash
  end
end
