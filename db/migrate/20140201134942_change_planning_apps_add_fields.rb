class ChangePlanningAppsAddFields < ActiveRecord::Migration

  def change
    add_column :planning_apps, :applicant, :string
    add_column :planning_apps, :app_property, :string
    add_column :planning_apps, :latitude, :decimal, precision: 8, scale: 6
    add_column :planning_apps, :longitude, :decimal, precision: 8, scale: 6
  end

end
