class AppRoad < ActiveRecord::Base

  has_many :planning_apps

  validates :name, uniqueness: true

end
