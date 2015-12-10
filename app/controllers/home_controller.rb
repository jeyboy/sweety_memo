class HomeController < ApplicationController
  def show
    if params[:search]

      return
    end

    @cated_posts = Post.categorize_by_topics
  end
end
