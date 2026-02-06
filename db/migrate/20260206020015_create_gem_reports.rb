class CreateGemReports < ActiveRecord::Migration[8.1]
  def change
    create_table :gem_reports do |t|
      t.references :repository, null: false, foreign_key: true
      t.string :name, null: false
      t.string :current_version, null: false
      t.string :latest_version, null: false
      t.integer :version_diff_type, null: false, default: 0
      t.string :changelog_url, null: false
      t.string :source_code_url, null: false
      t.string :homepage_url, null: false

      t.timestamps
    end
  end
end
