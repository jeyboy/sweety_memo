class Topic < ActiveRecord::Base
  belongs_to :category

  has_many :posts, dependent: :destroy

  validates :name, uniqueness: true, presence: true
end
