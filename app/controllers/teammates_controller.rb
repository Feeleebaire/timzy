class TeammatesController < ApplicationController
  before_action :set_team, only: [ :new, :create ]
  def new
    @teammates = @team.teammates
    @teammate = Teammate.new
    authorize @teammate
  end

  def create
    @teammate = Teammate.new
    @teammate.team = @team
    @teammate.email = params[:teammate][:email]
    puts params
    user = User.find_by_email(@teammate.email)
    @teammate.update(user: user) if user
    authorize @teammate
    if @teammate.save
      UserMailer.invitation(@teammate).deliver_now unless user
      respond_to do |format|
        format.html { redirect_to  team_teammate_path(@team) }
        format.js
      end
    else
      render :new
    end
  end

  private

  def teammate_params
    params.require(:teammate).permit(:email)
  end

  def set_team
    @team = Team.find(params[:team_id])
  end
end
