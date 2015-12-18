require 'previewer'
require 'cleaner'

class Post < ActiveRecord::Base
  CONTENT_TYPES = [
      TEXT_CONTENT = 1,
      VIDEO_CONTENT = 2
  ]

  belongs_to :topic

  validates :name, uniqueness: true, presence: true, length: { maximum: 254}
  validates :body, presence: true

  after_validation :unescape_and_prepare, if: :body_changed?

  scope :enabled, -> { where(disabled: false) }

  def preview
    unless preview_length
      unescape_and_prepare && save
    end

    if body.length > preview_length
      "#{body[0..preview_length]} ..."
    else
      body
    end
  end

  class << self
    def categorize_by_topics(count = 5)
      posts = Post.joins(topic: :category)
          .merge(Topic::enabled)
          .merge(Category::enabled)

      results = posts.
          select('topics.name topic_name, categories.name category_name, posts.*, ROW_NUMBER() OVER
         (PARTITION BY posts.topic_id ORDER BY RANDOM()) AS TN')

      results = Post.enabled.from("(#{results.to_sql}) posts").
          where('posts.TN <= ?', count)

      results.to_a.each_with_object({}) do |post, ret|
        (ret[post.category_name] ||= {})[post.topic_name] ||= []
        ret[post.category_name][post.topic_name] << post
      end
    end

    def search(term)
      {
        I18n.t('token.categories') =>  Category.where('name LIKE ?', "%#{term}%"),
        I18n.t('token.topics') => Topic.where('name LIKE ?', "%#{term}%"),
        I18n.t('token.posts') => Post.where('name LIKE :term OR body LIKE :term', term: "%#{term}%")
      }
    end
  end

  private
  def unescape_and_prepare
    case content_type
      when TEXT_CONTENT
        self.body = Cleaner.prepare_text(CGI.unescape(self.body))

        if errors.empty?
          self.preview_length = Previewer.prepare_preview(self.body).length
        end
      else
        self.body = (self.body.match(/((?:v=)|(?:embed\/))(?<code>\w+)/mix)[:code] rescue nil)
        errors.add(:youtube_url, 'Url should has valid format (www.youtube.com/watch?v=2hSKxFJbE_8)') unless self.body
    end
  end
end
