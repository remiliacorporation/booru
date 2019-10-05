class IqdbQueriesController < ApplicationController
  respond_to :html, :json
  before_action :detect_xhr

  def show
    if params[:url]
      access_denied("Not an allowed URL") if UploadWhitelist.is_whitelisted?(params[:url])
      @matches = IqdbProxy.query(params[:url])
    end

    if params[:post_id]
      @matches = IqdbProxy.query_path(Post.find(params[:post_id]).preview_file_path)
    end

    respond_with(@matches) do |fmt|
      fmt.html do |html|
        html.xhr { render layout: false}
      end

      fmt.json do
        render json: @matches
      end
    end
  end

private

  def detect_xhr
    if request.xhr?
      request.variant = :xhr
    end
  end
end
