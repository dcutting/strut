require "spec_helper"

include Strut

describe InteractionFactory do
  before do
    @sut = InteractionFactory.new
  end

  it 'makes an empty interaction for an empty path stack' do
    interaction = @sut.make_interaction([])
    expect(Interaction.new).to eq(interaction)
  end

  it 'populates the URI' do
    interaction = @sut.make_interaction(["paths", "/hello"])
    expected = Interaction.new("/hello")
    expect(expected).to eq(interaction)
  end

  it 'populates the URI and method' do
    interaction = @sut.make_interaction(["paths", "/hello", "post"])
    expected = Interaction.new("/hello", "post")
    expect(expected).to eq(interaction)
  end

  it 'does not populates the method if it is an x- tag' do
    interaction = @sut.make_interaction(["paths", "/hello", "x-scenario-configure"])
    expected = Interaction.new("/hello")
    expect(expected).to eq(interaction)
  end

  it 'populates the URI, method and status code' do
    interaction = @sut.make_interaction(["paths", "/hello", "post", "responses", "418"])
    expected = Interaction.new("/hello", "post", "418")
    expect(expected).to eq(interaction)
  end
end
