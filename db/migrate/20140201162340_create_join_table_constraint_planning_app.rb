class CreateJoinTableConstraintPlanningApp < ActiveRecord::Migration
  def change
    create_join_table :constraints, :planning_apps
    add_foreign_key(:constraints_planning_apps, :constraints)
    add_foreign_key(:constraints_planning_apps, :planning_apps)
  end
end
