module Previewer
  require 'nokogiri'
  mattr_accessor :max_length
  self.max_length = 250

  def self.prepare_preview(html)
    if html.length < max_length
      html
    else
      doc = Nokogiri::HTML(html)
      html_iterator_wrapper(doc.css('body'))
    end
  end

private
  def self.html_iterator_wrapper(block)
    html_iterator(block)
    block.inner_html
  end

  def self.html_iterator(block, counter = 0, lock = false)
    block.children.each do |child|
      if lock
        child.remove
      else
        if child.text?
          counter += (child_content = child.content).length
          if counter > max_length
            len = child_content.index("\n", (child_content.length - (counter - max_length))) || (child_content.length - 1 - (counter - max_length))
            (child.content = child_content[0..(len + 1)] + '...')
          end
        else
          counter, lock = html_iterator(child, counter, lock) unless ['a'].include?(child.node_name)
          lock = counter > max_length
        end
      end
    end
    [counter, lock]
  end
end