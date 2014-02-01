class Parish < ActiveRecord::Base

  has_many :planning_apps

  validates :name, presence: true, uniqueness: true

end
