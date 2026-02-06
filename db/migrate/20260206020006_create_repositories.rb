class CreateRepositories < ActiveRecord::Migration[8.1]
  def change
    create_table :repositories do |t|
      t.string :url, null: false
      t.string :name, null: false
      t.string :current_rails_version
      t.string :target_rails_version
      t.text :ai_analysis, null: false
      t.datetime :analyzed_at

      t.timestamps
    end

    add_index :repositories, :url
  end
end
