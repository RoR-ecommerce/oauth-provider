class OauthClientsController < ApplicationController

  def index
  end

  def show
    @client = Songkick::OAuth2::Model::Client.find_by_id(params[:id])
    render :json => @client.to_json
  end

  def new
    @client = Songkick::OAuth2::Model::Client.new
    render :json => @client.to_json
  end

  def create
    @client = Songkick::OAuth2::Model::Client.new(params)
    if @client.save!
      render :json => @client.to_json
    else
      render :json => {:errors => @client.errors.as_json}, :status => 420
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
