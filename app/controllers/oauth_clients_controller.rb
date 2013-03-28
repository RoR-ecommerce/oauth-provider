class OauthClientsController < ApplicationController
  include ActionController::MimeResponds
  include ActionController::StrongParameters

  respond_to :json

  def index
  end

  def show
    @client = Songkick::OAuth2::Model::Client.find_by_id(params[:id])
    respond_with(@client)
  end

  def new
    @client = Songkick::OAuth2::Model::Client.new
    respond_with(@client)
  end

  def create
    @client = Songkick::OAuth2::Model::Client.create(client_params)
    respond_with(@client)
  end

  def edit
    @client = Songkick::OAuth2::Model::Client.find_by_id(params[:id])
    respond_with(@client)
  end

  def update
    @client = Songkick::OAuth2::Model::Client.find_by_id(params[:id])
    @client.update_attributes!(client_params)
    respond_with(@client)
  end

  def destroy
    @client = Songkick::OAuth2::Model::Client.find_by_id(params[:id])
    @client.destroy
    respond_with(@client)

  end

  protected
    def client_params
      params.require(:oauth2_client).permit(:name, :redirect_uri)
    end
end
