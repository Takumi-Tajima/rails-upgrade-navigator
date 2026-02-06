class AddStatusToRepositories < ActiveRecord::Migration[8.1]
  def change
    add_column :repositories, :status, :integer, null: false, default: 0
  end
end
