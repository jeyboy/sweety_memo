class HomeController < ApplicationController
  def show
    @cated_posts = Post.categorize_by_topics
  end

  def search
    @term = (params[:search][:term] rescue nil)
    @results = (Post::search(@term) if @term.present?) || {}
  end
end
