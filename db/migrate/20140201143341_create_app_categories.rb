class CreateAppCategories < ActiveRecord::Migration
  def change
    create_table :app_categories do |t|
      t.string :code
      t.string :description

      t.timestamps
    end
    add_reference :planning_apps, :app_category, index: true
    add_foreign_key(:planning_apps, :app_categories)
  end
end
