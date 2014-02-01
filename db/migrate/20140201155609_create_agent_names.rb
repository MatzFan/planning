class CreateAgentNames < ActiveRecord::Migration
  def change
    create_table :agent_names do |t|
      t.string :name

      t.timestamps
    end
    add_reference :planning_apps, :agent_name, index: true
    add_foreign_key(:planning_apps, :agent_names)
  end
end
