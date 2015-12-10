require 'previewer'
require 'cleaner'

class Post < ActiveRecord::Base
  belongs_to :topic

  validates :name, uniqueness: true, presence: true, length: { maximum: 254}
  validates :body, presence: true

  after_validation :unescape_and_prepare, if: :body_changed?

  scope :enabled, -> { where(disabled: false) }

  def preview
    unless preview_length
      unescape_and_prepare && save
    end

    body[preview_length]
  end

  class << self
    def categorize_by_topics(count = 5)
      posts = Post.joins(topic: :category)
          .merge(Topic::enabled)
          .merge(Category::enabled)

      results = posts.
          select('topics.name topic_name, categories.name category_name, posts.*, ROW_NUMBER() OVER
         (PARTITION BY posts.topic_id ORDER BY RANDOM()) AS TN')

      results = Post.from("(#{results.to_sql}) posts").
          where('posts.TN <= ?', count)

      results.to_a.each_with_object({}) do |post, ret|
        (ret[post.category_name] ||= {})[post.topic_name] ||= []
        ret[post.category_name][post.topic_name] << post
      end
    end

    def search(term)
      {
        categories: Category.where('name LIKE ?', "%#{term}%"),
        topics: Topic.where('name LIKE ?', "%#{term}%"),
        posts: Post.where('name LIKE :term OR body LIKE :term', term: "%#{term}%")
      }
    end
  end

  private
  def unescape_and_prepare
    self.body = Cleaner.prepare_text(CGI.unescape(self.body))

    if errors.empty?
      self.preview_length = Previewer.prepare_preview(self.body).length
    end
  end
end
