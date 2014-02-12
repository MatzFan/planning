class PlanningAppsController < ApplicationController

  before_action :authenticate_user!, except: [:welcome]

  def welcome

  end

  def search
    @planning_apps = PlanningApp.search(params[:query]) # search is dusen method
  end

end
