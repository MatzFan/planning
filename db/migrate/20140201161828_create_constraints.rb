class CreateConstraints < ActiveRecord::Migration
  def change
    create_table :constraints do |t|
      t.string :name

      t.timestamps
    end
  end
end
