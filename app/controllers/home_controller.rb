class HomeController < ApplicationController
  def show
    @cated_posts = Post.categorize_by_topics
    respond
  end

  def search
    @term = (params[:search].try(:[], :term))
    @results = (Post::search(@term) if @term.present?) || {}
    respond
  end
end
