require "spec_helper"

include Strut

describe SlimCommandFactory do
  before do
    @sut = SlimCommandFactory.new
    @metadata = CommandMetadata.new(3, 15, "value")
  end

  it 'makes an import command' do
    actual = @sut.make_import_command(@metadata, "namespace")
    expect(actual.id).to eq("1")
    expect(actual.metadata).to eq(@metadata)
    expect(actual.namespace).to eq("namespace")
  end

  it 'makes a make command' do
    actual = @sut.make_make_command(@metadata, "instance", "class_name")
    expect(actual.id).to eq("1")
    expect(actual.metadata).to eq(@metadata)
    expect(actual.instance).to eq("instance")
    expect(actual.class_name).to eq("class_name")
  end

  it 'makes a call command' do
    actual = @sut.make_call_command(@metadata, "instance", "property", "value")
    expect(actual.id).to eq("1")
    expect(actual.metadata).to eq(@metadata)
    expect(actual.instance).to eq("instance")
    expect(actual.property).to eq("property")
    expect(actual.value).to eq("value")
  end

  it 'increments command IDs' do
    import_command = @sut.make_import_command(nil, "my_namespace")
    make_command = @sut.make_make_command(nil, "instance", "class")
    expect(import_command.id).to eq("1")
    expect(make_command.id).to eq("2")
  end
end
