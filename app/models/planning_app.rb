require 'app_scraper'

class PlanningApp < ActiveRecord::Base

  belongs_to :app_status
  belongs_to :app_category

  validate :reference, presence: true, uniqueness: true

end
