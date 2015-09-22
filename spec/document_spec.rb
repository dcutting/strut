require "spec_helper"

include Strut

describe Document do
  before do
    @metadata = CommandMetadata.new(10, 20, "value")
    cmd = ImportCommand.new(5, @metadata, "namespace")
    @sut = Document.new([cmd])
  end

  it 'returns the stored metadata for a given command ID' do
    actual = @sut.metadata_for_command_id(5)
    expect(actual).to eq(@metadata)
  end

  it 'returns nil if no metadata exists for a given command ID' do
    actual = @sut.metadata_for_command_id(4)
    expect(actual).to be_nil
  end
end
