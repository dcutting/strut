module Strut
  class ReportJUnitFormatter
    def format(report)
      doc = REXML::Document.new("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n")
      results = report.scenario_results
      add_testsuite(results, doc)
      doc.to_s
    end

    def add_testsuite(results, doc)
      testsuite = doc.add_element("testsuite")
      results.each do |scenario|
        add_testcase_for_scenario(scenario, testsuite)
      end
    end

    def add_testcase_for_scenario(scenario, testsuite)
      testcase = testsuite.add_element("testcase")
      testcase.attributes["name"] = scenario.name
      testcase.attributes["time"] = scenario.time
      testcase.attributes["classname"] = "swagger"
      add_result_for_testcase(scenario, testcase)
    end

    def add_result_for_testcase(scenario, testcase)
      if scenario.result == SCENARIO_FAIL
        add_failure_for_testcase(scenario.message, testcase)
      elsif scenario.result == SCENARIO_ERROR
        add_error_for_testcase(scenario.message, testcase)
      end
    end

    def add_failure_for_testcase(message, testcase)
      add_element_for_testcase("failure", testcase, message, "assert")
    end

    def add_error_for_testcase(message, testcase)
      add_element_for_testcase("error", testcase, message, "exception")
    end

    def add_element_for_testcase(element, testcase, message, type)
      node = testcase.add_element(element)
      node.attributes["message"] = message
      node.attributes["type"] = type
    end
  end
end
