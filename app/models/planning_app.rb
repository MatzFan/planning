require 'scraper'

class PlanningApp < ActiveRecord::Base

  validate :reference, presence: true, uniqueness: true

  def self.new_apps(ref)
    Scraper::scrape(ref)
  end

end
