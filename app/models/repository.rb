class Repository < ApplicationRecord
  extend Enumerize

  RAILS_VERSIONS = %w[
    6.0.0 6.0.1 6.0.2 6.0.3 6.0.4 6.0.5 6.0.6
    6.1.0 6.1.1 6.1.2 6.1.3 6.1.4 6.1.5 6.1.6 6.1.7
    7.0.0 7.0.1 7.0.2 7.0.3 7.0.4 7.0.5 7.0.6 7.0.7 7.0.8
    7.1.0 7.1.1 7.1.2 7.1.3 7.1.4 7.1.5
    7.2.0 7.2.1 7.2.2
    8.0.0 8.0.1 8.0.2
  ].freeze

  has_many :gem_reports, dependent: :destroy

  enumerize :status, in: { pending: 0, analyzing: 1, completed: 2, failed: 3 }, default: :pending, scope: true

  attribute :target_rails_version, default: ''
  attribute :ai_analysis, default: ''

  validates :url, presence: true, format: { with: %r{\Ahttps://github\.com/[^/]+/[^/]+\z} }
  validates :name, presence: true

  scope :default_order, -> { order(analyzed_at: :desc) }

  before_validation :extract_name_from_url

  def full_name
    url&.match(%r{\Ahttps://github\.com/(?<full>[^/]+/[^/]+)\z})&.[](:full)
  end

  def available_target_versions
    return [] if current_rails_version.blank?

    current = Gem::Version.new(current_rails_version)
    RAILS_VERSIONS.select { |v| Gem::Version.new(v) > current }
  rescue ArgumentError
    []
  end

  def fetch_gemfile_lock
    client = Octokit::Client.new
    content = client.contents(full_name, path: 'Gemfile.lock')
    Base64.decode64(content.content)
  rescue Octokit::NotFound
    raise GemfileLockNotFoundError, 'Gemfile.lockが見つかりませんでした'
  rescue Octokit::InvalidRepository
    raise InvalidRepositoryError, 'リポジトリが見つかりませんでした'
  end

  def parse_gemfile_lock(content)
    lockfile = Bundler::LockfileParser.new(content)
    lockfile.specs.map { |spec| { name: spec.name, version: spec.version.to_s } }
  end

  def analyze
    update!(status: :analyzing)

    content = fetch_gemfile_lock
    gems = parse_gemfile_lock(content)

    rails_gem = gems.find { |g| g[:name] == 'rails' }
    self.current_rails_version = rails_gem[:version] if rails_gem

    gem_reports.destroy_all

    gems.each do |gem_info|
      gem_report = gem_reports.build(
        name: gem_info[:name],
        current_version: gem_info[:version]
      )

      info = RubyGem.fetch_info(gem_info[:name])
      if info
        gem_report.latest_version = info[:version]
        gem_report.changelog_url = info[:changelog_url]
        gem_report.source_code_url = info[:source_code_url]
        gem_report.homepage_url = info[:homepage_url]
      end

      gem_report.version_diff_type = gem_report.calculate_version_diff
      gem_report.save!
    end

    self.analyzed_at = Time.current
    self.status = :completed
    save!
  rescue StandardError => e
    update!(status: :failed)
    raise e
  end

  private

  def extract_name_from_url
    match = url&.match(%r{\Ahttps://github\.com/[^/]+/(?<repo>[^/]+)\z})
    self.name = match[:repo] if match
  end
end

class GemfileLockNotFoundError < StandardError; end
class InvalidRepositoryError < StandardError; end
