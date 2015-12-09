class Post < ActiveRecord::Base
  belongs_to :topic

  validates :name, uniqueness: true, presence: true
  validates :body, presence: true
end
