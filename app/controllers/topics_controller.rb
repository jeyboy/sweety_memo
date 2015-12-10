class TopicsController < ApplicationController
  before_action :set_topic, only: [:show]

  def index
    @topics = paginate(Topic.enabled)
  end

  def show
    @posts = paginate(@topic.posts.enabled)
  end

  private
    def set_topic
      redirect_to(:back, alert: 'Object is not existed') unless (@topic = Topic.enabled.find_by(id: params[:id].to_i))
    end
end
