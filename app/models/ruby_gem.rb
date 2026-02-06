class RubyGem
  def self.fetch_info(name)
    uri = URI("https://rubygems.org/api/v1/gems/#{name}.json")
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    {
      version: data['version'],
      changelog_url: data['changelog_uri'] || '',
      source_code_url: data['source_code_uri'] || '',
      homepage_url: data['homepage_uri'] || ''
    }
  rescue StandardError
    nil
  end
end
