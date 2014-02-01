class Constraint < ActiveRecord::Base

  has_and_belongs_to_many :planning_apps

  validates :name, presence: true, uniqueness: true

end
