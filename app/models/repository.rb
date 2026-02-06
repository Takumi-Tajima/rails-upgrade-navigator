class Repository < ApplicationRecord
  has_many :gem_reports, dependent: :destroy

  validates :url, presence: true, format: { with: %r{\Ahttps://github\.com/[^/]+/[^/]+\z} }
  validates :name, presence: true

  attribute :target_rails_version, default: ''
  attribute :ai_analysis, default: ''

  scope :default_order, -> { order(analyzed_at: :desc) }
end
