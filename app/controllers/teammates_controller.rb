class TeammatesController < ApplicationController
  before_action :set_team, only: [ :new, :create ]
  def new
    @teammate = Teammate.new
    authorize @teammate
  end

  def create
    @teammate = Teammate.new(teammate_params)
    @teammate.team = @team
    user = User.find_by_email(@teammate.email)
    if user
      @teammate.update(user: user)
    else
      UserMailer.invitation(@teammate).deliver_now
    end
    if @teammate.save
      redirect_to root
    else
      render :new
    end
    authorize @teammate
  end

  private

  def teammate_params
    params.require(:teammate).permit(:email)
  end

  def set_team
    @team = Team.find(params[:team_id])
  end
end
