require "spec_helper"

include Strut

describe InteractionFactory do
  before do
    @sut = InteractionFactory.new
  end

  it 'makes an empty interaction for an empty path stack' do
    actual = @sut.make_interaction([])
    expected = Interaction.new
    expect(Interaction.new).to eq(actual)
  end

  it 'populates the URI' do
    actual = @sut.make_interaction(["paths", "/hello"])
    expected = Interaction.new("/hello")
    expect(expected).to eq(actual)
  end

  it 'does not populate the URI if it is an x- tag' do
    actual = @sut.make_interaction(["paths", "x-scenario-configure"])
    expected = Interaction.new
    expect(expected).to eq(actual)
  end

  it 'populates the URI and method' do
    actual = @sut.make_interaction(["paths", "/hello", "post"])
    expected = Interaction.new("/hello", "post")
    expect(expected).to eq(actual)
  end

  it 'does not populate the method if it is an x- tag' do
    actual = @sut.make_interaction(["paths", "/hello", "x-scenario-configure"])
    expected = Interaction.new("/hello")
    expect(expected).to eq(actual)
  end

  it 'populates the URI, method and status code' do
    actual = @sut.make_interaction(["paths", "/hello", "post", "responses", "418"])
    expected = Interaction.new("/hello", "post", "418")
    expect(expected).to eq(actual)
  end
end
