require "spec_helper"

include Strut

describe SlimCommandFactory do
  it 'increments command IDs' do
    sut = SlimCommandFactory.new
    import_command = sut.make_import_command(nil, "my_namespace")
    make_command = sut.make_make_command(nil, "instance", "class")
    expect(import_command.id).to eq("1")
    expect(make_command.id).to eq("2")
  end
end
