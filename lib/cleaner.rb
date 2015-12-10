module Cleaner
  require 'nokogiri'

  WRONG_STYLES_REGEX = /(position|top|bottom|left|right|width|height|float|(margin(-[^:]+)?)|(padding(-[^:]+)?)):[^;]*;?/mix

  def self.prepare_text(text)
    doc = Nokogiri::HTML(text)
    prepare_nokogiri(doc)
  end

  def self.prepare_nokogiri(doc)
    #doc.xpath('//@style').remove # strip all styles

    doc.xpath('//@style').each do |node|
      node.value = node.value.gsub(WRONG_STYLES_REGEX, '')
    end

    doc.xpath('//*[not(self::code)]/@class').remove # strip all classes
    doc.xpath('//@id').remove # strip all ides
    doc.css('body').inner_html
  end
end