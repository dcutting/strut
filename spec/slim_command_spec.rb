require "spec_helper"

include Strut

describe ImportCommand do
  before do
    @sut = ImportCommand.new(5, nil, "my_namespace")
  end

  it 'converts to a rubyslim array' do
    cmd_ary = @sut.to_a
    expect(cmd_ary).to eq([5, "import", "my_namespace"])
  end

  it 'prints like this' do
    expect(@sut.to_s).to eq("[ 5] import my_namespace")
  end
end

describe MakeCommand do
  before do
    @sut = MakeCommand.new(11, nil, "my_instance", "my_class_name")
  end

  it 'converts to a rubyslim array' do
    cmd_ary = @sut.to_a
    expect(cmd_ary).to eq([11, "make", "my_instance", "my_class_name"])
  end

  it 'prints like this' do
    expect(@sut.to_s).to eq("[11] my_instance = new my_class_name")
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

  it 'prints getter like this' do
    cmd = CallCommand.new(5, nil, "my_instance", "get_value", nil)
    expect(cmd.to_s).to eq("[ 5] my_instance.get_value()")
  end

  it 'prints setter like this' do
    cmd = CallCommand.new(5, nil, "my_instance", "set_value", "hello")
    expect(cmd.to_s).to eq("[ 5] my_instance.set_value(hello)")
  end
end
