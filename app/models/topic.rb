class Topic < ActiveRecord::Base
  belongs_to :category

  has_many :posts, dependent: :destroy

  validates :name, uniqueness: true, presence: true, length: { maximum: 254}

  scope :enabled, -> { where(disabled: false) }
end
