class Post < ActiveRecord::Base
  belongs_to :topic

  validates :name, uniqueness: true, presence: true, length: { maximum: 254}
  validates :body, presence: true

  scope :enabled, -> { where(disabled: false) }

  def self.categorize_by_topics(count = 5)
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

  def self.search(term)
    {

    }
  end
end
