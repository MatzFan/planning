class AppCategory < ActiveRecord::Base

  has_many :planning_apps

  validates :code, presence: true, uniqueness: true
  validates :description, uniqueness: true

end
