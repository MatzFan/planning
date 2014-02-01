require 'app_scraper'

class PlanningApp < ActiveRecord::Base

  belongs_to :app_status
  belongs_to :app_category
  belongs_to :parish

  validate :reference, presence: true, uniqueness: true

end
