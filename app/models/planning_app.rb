require 'app_scraper'

class PlanningApp < ActiveRecord::Base

  belongs_to :app_status
  belongs_to :app_category
  belongs_to :parish
  belongs_to :agent_name
  belongs_to :officer
  belongs_to :app_road
  belongs_to :app_postcode
  has_and_belongs_to_many :constraints

  validate :reference, presence: true, uniqueness: true

end
