class CreatePlanningApps < ActiveRecord::Migration
  def change
    create_table :planning_apps do |t|
      t.string :reference, null: false, unique: true
      t.text :description

      t.timestamps
    end
  end
end
