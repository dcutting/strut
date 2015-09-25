require "nokogiri"

module Strut
  class ReportJUnitFormatter
    def format(report)
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.testsuite = nil
      end
      builder.to_xml
    end
  end
end