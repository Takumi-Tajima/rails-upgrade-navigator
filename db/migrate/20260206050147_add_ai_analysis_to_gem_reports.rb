class AddAiAnalysisToGemReports < ActiveRecord::Migration[8.1]
  def change
    add_column :gem_reports, :ai_analysis, :text, null: false, default: ''
  end
end
