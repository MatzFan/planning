class CreateAppPostcodes < ActiveRecord::Migration
  def change
    create_table :app_postcodes do |t|
      t.string :code

      t.timestamps
    end
    add_reference :planning_apps, :app_postcode, index: true
    add_foreign_key(:planning_apps, :app_postcodes)
  end
end
