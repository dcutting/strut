require "spec_helper"

include Strut

describe ImportCommand do
  it 'converts to a rubyslim array' do
    cmd = ImportCommand.new(5, nil, "my_namespace")
    cmd_ary = cmd.to_a
    expect(cmd_ary).to eq([5, "import", "my_namespace"])
  end
end

describe MakeCommand do
  it 'converts to a rubyslim array' do
    cmd = MakeCommand.new(5, nil, "my_instance", "my_class_name")
    cmd_ary = cmd.to_a
    expect(cmd_ary).to eq([5, "make", "my_instance", "my_class_name"])
  end
end

describe CallCommand do
  it 'converts to a rubyslim array' do
    cmd = CallCommand.new(5, nil, "my_instance", "my_property", "a value")
    cmd_ary = cmd.to_a
    expect(cmd_ary).to eq([5, "call", "my_instance", "my_property", "a value"])
  end

  it 'does not convert call values to strings' do
    cmd = CallCommand.new(5, nil, "my_instance", "setvalue", 5)
    actual = cmd.to_a.last
    expected = 5
    expect(expected).to eq(actual)
  end
end
