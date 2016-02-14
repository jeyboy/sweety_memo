class TopicsController < ApplicationController
  before_action :set_topic, only: [:show]

  def index
    @topics = paginate(Topic.enabled)
    respond
  end

  def show
    @posts = paginate(@topic.posts.enabled)
    respond
  end

  private
    def set_topic
      respond_with_error unless (@topic = find_obj(Topic.enabled, params[:id]))
    end
end
