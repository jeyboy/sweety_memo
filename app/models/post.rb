class Post < ActiveRecord::Base
  belongs_to :topic

  validates :name, uniqueness: true, presence: true, length: { maximum: 254}
  validates :body, presence: true

  scope :enabled, -> { where(disabled: false) }
end
