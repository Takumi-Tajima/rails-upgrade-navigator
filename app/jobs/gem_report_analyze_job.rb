class GemReportAnalyzeJob < ApplicationJob
  queue_as :default

  def perform(gem_report)
    gem_report.analyze_with_ai
  end
end
