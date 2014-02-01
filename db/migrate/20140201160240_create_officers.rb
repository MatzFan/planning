class CreateOfficers < ActiveRecord::Migration
  def change
    create_table :officers do |t|
      t.string :name

      t.timestamps
    end
    add_reference :planning_apps, :officer, index: true
    add_foreign_key(:planning_apps, :officers)
  end
end
