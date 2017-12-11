class Apps::ConfigsController < Apps::ApplicationController
  before_action :set_app
  before_action :set_config, only: [:show, :update, :destroy]

  def index
    @configs = @app.configs.all
  end

  def show
  end

  def create
    @config = @app.configs.new(config_params)
    @config.save!
    render :show, status: :created, location: app_config_url(@app.name, @config.key)
  end

  def update
    @config.update!(config_params)
    render :show, status: :ok, location: app_config_url(@app.name, @config.key)
  end

  def destroy
    @config.destroy
  end

  private

  def set_config
    @config = @app.configs.find_by_key(params[:key])
  end

  def config_params
    params.require(:config).permit(:key, :value, :data_type)
  end
end
