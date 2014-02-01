class AppPostcode < ActiveRecord::Base

  has_many :planning_apps

  validates :code, uniqueness: true

end
