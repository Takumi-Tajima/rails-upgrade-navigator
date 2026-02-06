class GemReport < ApplicationRecord
  extend Enumerize

  belongs_to :repository

  validates :name, presence: true
  validates :current_version, presence: true

  enumerize :version_diff_type, in: { unknown: 0, up_to_date: 1, patch: 2, minor: 3, major: 4 }, default: :unknown, scope: true
  enumerize :ai_status, in: { pending: 0, analyzing: 1, completed: 2, failed: 3 }, default: :pending, scope: true

  attribute :latest_version, default: ''
  attribute :changelog_url, default: ''
  attribute :source_code_url, default: ''
  attribute :homepage_url, default: ''

  scope :default_order, -> { order(version_diff_type: :desc) }

  def calculate_version_diff
    return :unknown if latest_version.blank?
    return :up_to_date if current_version == latest_version

    current = Gem::Version.new(current_version)
    latest = Gem::Version.new(latest_version)

    if current.segments[0] != latest.segments[0]
      :major
    elsif current.segments[1] != latest.segments[1]
      :minor
    else
      :patch
    end
  rescue ArgumentError
    :unknown
  end

  def analyze_with_ai
    update!(ai_status: :analyzing)
    result = ChangelogAnalyzer.analyze(self)
    update!(ai_analysis: result, ai_status: :completed)
  rescue StandardError => e
    update!(ai_status: :failed)
    raise e
  end

  def ai_analyzed?
    ai_status.completed?
  end

  def ai_analyzing?
    ai_status.analyzing?
  end
end
