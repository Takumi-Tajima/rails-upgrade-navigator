module ApplicationHelper
  def markdown(text)
    return '' if text.blank?

    renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
    markdown = Redcarpet::Markdown.new(renderer, autolink: true, tables: true, fenced_code_blocks: true)
    markdown.render(text).html_safe
  end
end
