class PlanningApp < ActiveRecord::Base

  validate :reference, presence: true, uniqueness: true

end
