class GemReportsController < ApplicationController
  def show
    @gem_report = GemReport.find(params[:id])
    @repository = @gem_report.repository
  end

  def update
    @gem_report = GemReport.find(params[:id])
    @gem_report.analyze_with_ai
    redirect_to [Repository.find(params[:repository_id]), @gem_report], notice: 'AI分析が完了しました'
  end
end
