module Strut
  class ReportJunit
    def format(report)
      result = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<testsuite>
</testsuite>
XML
      result
    end
  end
end
