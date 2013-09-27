class MarkdownConverter
  def self.convert(text)
    @converter.render(text)
  end

  def convert(text)
    @converter.render(text)
  end
end


class MarkdownTopicConverter < MarkdownConverter
  def self.format(raw)
    text = raw.clone
    return '' if text.blank?

    convert_bbcode_img(text)
    users = normalize_user_mentions(text)

    # 如果 ``` 在刚刚换行的时候 Redcapter 无法生成正确，需要两个换行
    text.gsub!("\n```","\n\n```")

    result = text

    doc = Nokogiri::HTML.fragment(result)
    #link_mention_floor(doc)
    link_mention_user(doc, users)
    #replace_emoji(doc)

    return doc.to_html.strip
  rescue => e
    puts "MarkdownTopicConverter.format ERROR: #{e}"
    return text
  end

  class << self 

  # convert bbcode-style image tag [img]url[/img] to markdown syntax ![alt](url)
  def convert_bbcode_img(text)
    text.gsub!(/\[img\](.+?)\[\/img\]/i) {"![#{image_alt $1}](#{$1})"}
  end

  def image_alt(src)
    File.basename(src, '.*').capitalize
  end

  # borrow from html-pipeline
  def has_ancestors?(node, tags)
    while node = node.parent
      if tags.include?(node.name.downcase)
        break true
      end
    end
  end

  NORMALIZE_USER_REGEXP = /(^|[^a-zA-Z0-9_!#\$%&*@＠])@([a-zA-Z0-9_]{1,20})/io
  LINK_USER_REGEXP = /(^|[^a-zA-Z0-9_!#\$%&*@＠])@(user[0-9]{1,6})/io

  # rename user name using incremental id
  def normalize_user_mentions(text)
    users = []

    text.gsub!(NORMALIZE_USER_REGEXP) do
      prefix = $1
      user = $2
      users.push(user)
      "#{prefix}@user#{users.size}"
    end

    users
  end

  def link_mention_user(doc, users)
    link_mention_user_in_text(doc, users)
    link_mention_user_in_code(doc, users)
  end

  # convert '@user' to link
  # match any user even not exist.
  def link_mention_user_in_text(doc, users)
    doc.search('text()').each do |node|
      content = node.to_html
      next if !content.include?('@')
      in_code = has_ancestors?(node, %w(pre code))
      content.gsub!(LINK_USER_REGEXP) {
        prefix = $1
        user_placeholder = $2
        user_id = user_placeholder.sub(/^user/, '').to_i
        user = users[user_id - 1] || user_placeholder

        if in_code
          "#{prefix}@#{user}"
        else
          %(#{prefix}<a href="/#{user}" class="at_user" title="@#{user}"><i>@</i>#{user}</a>)
        end
      }

      node.replace(content)
    end
  end

  # Some code highlighter mark `@` and following characters as different
  # syntax class.
  def link_mention_user_in_code(doc, users)
    doc.css('pre.highlight span').each do |node|
      if node.previous && node.previous.inner_html == '@' && node.inner_html =~ /\Auser(\d+)\z/
        user_id = $1
        user = users[user_id.to_i - 1]
        if user
          node.inner_html = user
        end
      end
    end
  end

end

end