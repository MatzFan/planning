class AppStatus < ActiveRecord::Base

  has_many :planning_apps

  validates :description, presence: true, uniqueness: true

end
