class CreateAppRoads < ActiveRecord::Migration
  def change
    create_table :app_roads do |t|
      t.string :name

      t.timestamps
    end
    add_reference :planning_apps, :app_road, index: true
    add_foreign_key(:planning_apps, :app_roads)
  end
end
