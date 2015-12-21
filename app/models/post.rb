require 'previewer'
require 'cleaner'

class Post < ActiveRecord::Base
  CONTENT_TYPES = {
      (TEXT_CONTENT = 1) => 'posts',
      (VIDEO_CONTENT = 2) => 'videos'
  }

  belongs_to :topic

  validates :name, uniqueness: true, presence: true, length: { maximum: 254}
  validates :body, presence: true

  after_validation :unescape_and_prepare, if: :body_changed?

  scope :enabled, -> { where(disabled: false) }

  def self.content_type_str(type_id)
    Post::CONTENT_TYPES[type_id.to_i]
  end

  def content_type_str
    Post.content_type_str(content_type)
  end

  def readable_content_type
    content_type_str.singularize.humanize
  end

  def content
    case content_type
      when TEXT_CONTENT
        body
      else
        "<iframe src='//www.youtube.com/embed/#{body}?rel=0&html5=1' width='480' height='400' allowfullscreen></iframe>"
        # -#"http://www.youtube.com/embed/?listType=user_uploads&list=YOURCHANNELNAME"
        # -#&showinfo=0 — используя данную переменную вы сможете убрать название и рейтинг из плеера.
        # -#&egm=0 — сможете активировать расширенное всплывающее меню.
        # -#&autoplay=0 — создадите запрет на автоматическое проигрывание ролика.
        # -#&loop=0 — запрет на повтор ролика после просмотра, если ролик в плеере один.
        # -#&border=0 — убирается рамка плеера. Цветовая палитра задается параметром color1, дополнительный цвет — параметром color2. Значения можно задать RGB в шестнадцатеричном формате.
        # -#&fmt=6 — задаёт хорошее качество видео.
        # -#&fmt=18 — задаёт качество еще лучше.
        # -#&fmt=22 — задаёт наилучшее качество видео. Но для работы этого параметра видео должно быть в high definition (HD).
        # -#&disablekb=1 — отключение управления клавиатурой компьютера.
        # -#&fs=0 — делает невозможным полноэкранный просмотр.
        # -#&start=331 — запускает видео с 331 секунды. Задайте своё число секунд.
        # -#&showsearch=0 — окна поиска не отображается при уменьшенном виде плеера.
        # -#&start=10 — запуск видео через 10 секунд после загрузки. Задавайте своё кол-во секунд.
    end
  end

  def preview
    case content_type
      when TEXT_CONTENT
        unless preview_length
          unescape_and_prepare && save
        end

        if body.length > preview_length
          "#{body[0..preview_length]} ..."
        else
          body
        end

      else
        content
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
        self.body = (self.body.match(/((?:v=)|(?:embed\/))(?<code>\w+)/mix)[:code] rescue self.body)
        errors.add(:youtube_url, 'Url should has valid format (www.youtube.com/watch?v=2hSKxFJbE_8)') unless self.body
    end
  end
end
