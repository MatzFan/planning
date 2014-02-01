class CreateAppStatuses < ActiveRecord::Migration
  def change
    create_table :app_statuses do |t|
      t.string :description

      t.timestamps
    end
    add_reference :planning_apps, :app_status, index: true
    add_foreign_key(:planning_apps, :app_statuses)
  end
end
