require "spec_helper"

include Strut

describe ImportCommand do
  it 'converts to a rubyslim array' do
    cmd = ImportCommand.new(5, "my_namespace")
    cmd_ary = cmd.to_a
    expect(cmd_ary).to eq([5, "import", "my_namespace"])
  end
end

describe MakeCommand do
  it 'converts to a rubyslim array' do
    cmd = MakeCommand.new(5, "my_instance", "my_class_name")
    cmd_ary = cmd.to_a
    expect(cmd_ary).to eq([5, "make", "my_instance", "my_class_name"])
  end
end

describe CallCommand do
  it 'converts to a rubyslim array without the optional value' do
    cmd = CallCommand.new(5, "my_instance", "my_property")
    cmd_ary = cmd.to_a
    expect(cmd_ary).to eq([5, "call", "my_instance", "my_property"])
  end

  it 'converts to a rubyslim array with the optional value' do
    cmd = CallCommand.new(5, "my_instance", "my_property", "a value")
    cmd_ary = cmd.to_a
    expect(cmd_ary).to eq([5, "call", "my_instance", "my_property", "a value"])
  end
end
