class CreateParishes < ActiveRecord::Migration
  def change
    create_table :parishes do |t|
      t.string :name

      t.timestamps
    end
    add_reference :planning_apps, :parish, index: true
    add_foreign_key(:planning_apps, :parishes)
  end
end
