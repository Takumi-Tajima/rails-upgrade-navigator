class ChangelogAnalyzer
  def self.analyze(gem_report)
    return '' if gem_report.changelog_url.blank?

    client = Anthropic::Client.new(api_key: Rails.application.credentials.anthropic.api_key)
    response = client.messages.create(
      model: 'claude-sonnet-4-20250514',
      max_tokens: 2048,
      tools: [
        {
          type: 'web_search_20250305',
          name: 'web_search',
          max_uses: 3,
        },
      ],
      messages: [
        {
          role: 'user',
          content: build_prompt(gem_report),
        },
      ]
    )

    extract_text_response(response)
  rescue Anthropic::Errors::APIError => e
    "分析中にエラーが発生しました: #{e.message}"
  end

  def self.extract_text_response(response)
    response.content
            .select { |block| block.type == :text }
            .map(&:text)
            .join("\n")
  end

  def self.build_prompt(gem_report)
    <<~PROMPT
      以下のRuby gemのChangelogを分析して、バージョンアップ時の注意点を日本語でまとめてください。

      ## gem情報
      - gem名: #{gem_report.name}
      - 現在のバージョン: #{gem_report.current_version}
      - 最新バージョン: #{gem_report.latest_version}
      - Changelog URL: #{gem_report.changelog_url}

      ## 分析してほしい内容
      1. #{gem_report.current_version} から #{gem_report.latest_version} までの間にあるBreaking Changes（破壊的変更）
      2. 非推奨になった機能（Deprecations）
      3. アップデート時に特に注意すべき点
      4. 推奨されるアップデート手順

      上記のChangelog URLを検索して内容を確認し、分析結果をMarkdown形式で出力してください。
      Changelogが見つからない場合や読み取れない場合は、その旨を伝えてください。
    PROMPT
  end
end
