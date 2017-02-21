class WebsitesController < ApplicationController
   before_action :set_website, only: [:show, :edit, :update, :destroy]

  def index
    @websites = policy_scope(Website) # website.all
  end

  def show
  end

  def new
    @team = Team.find(params[:team_id])
    @website = Website.new
    authorize(@website)
  end

  def create
    @website = Website.new(website_params)
    @website.team = Team.find(params[:team_id])
    authorize(@website)
    if @website.save
      redirect_to teams_path , notice: 'Your website was successfully created.'
    else
      render :new
    end
  end

  private

  def edit
  end

  def update
    if @website.update(website_params)
      redirect_to @website , notice: 'Your website was successfully edited.'
    else
      render :edit
    end
  end

   def destroy
    @website.destroy
    redirect_to websites_url, notice: 'Your website was successfully destroyed.'
  end


private

  def website_params
    params.require(:website).permit(:name, :url)
  end

  def set_website
    @website = website.find(params[:id])
    authorize(@website)
  end
end
