class AddAiStatusToGemReports < ActiveRecord::Migration[8.1]
  def change
    add_column :gem_reports, :ai_status, :integer, null: false, default: 0
  end
end
