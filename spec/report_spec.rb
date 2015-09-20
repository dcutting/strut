require "spec_helper"

include Strut

describe Report do
  before do
    @sut = Report.new
  end

  it 'reports 1 total scenario for a single ok' do
    @sut.add_ok_for_line(1, 1)
    expect(@sut.number_scenarios).to eq(1)
    expect(@sut.number_passed).to eq(1)
    expect(@sut.number_failed).to eq(0)
    expect(@sut.number_skipped).to eq(0)
  end

  it 'reports 1 total scenario for a single fail' do
    @sut.add_fail_for_line(1, 1, "failed")
    expect(@sut.number_scenarios).to eq(1)
    expect(@sut.number_passed).to eq(0)
    expect(@sut.number_failed).to eq(1)
    expect(@sut.number_skipped).to eq(0)
  end

  it 'reports 1 total scenario for a single exception' do
    @sut.add_exception_for_line(1, 1, "exception")
    expect(@sut.number_scenarios).to eq(1)
    expect(@sut.number_passed).to eq(0)
    expect(@sut.number_failed).to eq(0)
    expect(@sut.number_skipped).to eq(1)
  end

  it 'reports 1 total scenario for an ok, fail and exception for the same scenario' do
    @sut.add_ok_for_line(1, 1)
    @sut.add_fail_for_line(1, 1, "failed")
    @sut.add_exception_for_line(1, 1, "exception")
    expect(@sut.number_scenarios).to eq(1)
    expect(@sut.number_passed).to eq(0)
    expect(@sut.number_failed).to eq(0)
    expect(@sut.number_skipped).to eq(1)
  end

  it 'reports correctly for multiple scenarios' do
    @sut.add_ok_for_line(1, 1)
    @sut.add_ok_for_line(1, 2)
    @sut.add_fail_for_line(2, 1, "failed")
    @sut.add_exception_for_line(3, 1, "exception")
    expect(@sut.number_scenarios).to eq(3)
    expect(@sut.number_passed).to eq(1)
    expect(@sut.number_failed).to eq(1)
    expect(@sut.number_skipped).to eq(1)
  end

  it 'handles annotations with no scenario number' do
    @sut.add_ok_for_line(nil, 1)
    expect(@sut.number_scenarios).to eq(0)
    expect(@sut.number_passed).to eq(0)
    expect(@sut.number_failed).to eq(0)
    expect(@sut.number_skipped).to eq(0)
  end

  it 'returns an OK annotation for a line that has just that annotation' do
    @sut.add_ok_for_line(1, 1)
    actual = @sut.annotation_for_line(1)
    expected = Annotation.new(ANNOTATION_OK, "")
    expect(actual).to eq(expected)
  end
end
