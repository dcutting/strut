require "nokogiri"

include Nokogiri::XML

module Strut
  class ReportJUnitFormatter
    def format(report)
      doc = DocumentFragment.parse("")
      results = report.scenario_results
      add_testsuite(results, doc)
      doc.to_xml
    end

    def add_testsuite(results, doc)
      testsuite = Node.new("testsuite", doc)
      results.each do |scenario|
        add_testcase_for_scenario(scenario, testsuite)
      end
      doc.add_child(testsuite)
    end

    def add_testcase_for_scenario(scenario, testsuite)
      testcase = Node.new("testcase", testsuite)
      testcase.set_attribute("name", scenario.name)
      testcase.set_attribute("time", scenario.time)
      testcase.set_attribute("classname", "swagger")
      add_result_for_testcase(scenario, testcase)
      testsuite.add_child(testcase)
    end

    def add_result_for_testcase(scenario, testcase)
      if scenario.result == SCENARIO_FAIL
        add_failure_for_testcase(scenario.message, testcase)
      end
    end

    def add_failure_for_testcase(message, testcase)
      failure = Node.new("failure", testcase)
      failure.set_attribute("message", message)
      failure.set_attribute("type", "")
      testcase.add_child(failure)
    end
  end
end
