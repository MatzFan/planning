class AddDatesToPlanningApp < ActiveRecord::Migration

  def change
    change_table :planning_apps do |t|
      t.date :validated
      t.date :advertised
      t.date :end_publicity
      t.date :site_visited
      t.date :panel_ministerial
      t.date :decision
      t.date :appeal
    end
  end

end
