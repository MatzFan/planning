class PlanningAppsController < ApplicationController

  # before_action :authenticate_user!, except: [:welcome]

  def index
    @planning_apps = PlanningApp.search(params[:query])[0..29] # search is dusen method
  end

end
