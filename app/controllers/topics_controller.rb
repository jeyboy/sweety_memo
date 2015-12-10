class TopicsController < ApplicationController
  before_action :set_topic, only: [:show]

  def index
    @topics = paginate(Topic.enabled)
  end

  def show
    @posts = paginate(@topic.posts)
  end

  private
    def set_topic
      redirect_to :back unless (@topic = Topic.enabled.find_by(id: params[:id].to_i))
    end
end
