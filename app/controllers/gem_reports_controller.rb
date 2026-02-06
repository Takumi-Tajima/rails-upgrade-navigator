class GemReportsController < ApplicationController
  def show
    @gem_report = GemReport.find(params[:id])
    @repository = @gem_report.repository
  end

  def update
    @gem_report = GemReport.find(params[:id])
    GemReportAnalyzeJob.perform_later(@gem_report)
    redirect_to [Repository.find(params[:repository_id]), @gem_report], notice: 'AI分析を開始しました'
  end
end
