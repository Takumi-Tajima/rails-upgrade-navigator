class GemReport < ApplicationRecord
  extend Enumerize

  belongs_to :repository

  validates :name, presence: true
  validates :current_version, presence: true

  enumerize :version_diff_type, in: %i[unknown up_to_date patch minor major]

  attribute :latest_version, default: ''
  attribute :changelog_url, default: ''
  attribute :source_code_url, default: ''
  attribute :homepage_url, default: ''

  scope :default_order, -> { order(version_diff_type: :desc) }
end
