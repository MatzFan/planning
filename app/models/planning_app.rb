require 'app_scraper'

class PlanningApp < ActiveRecord::Base

  validate :reference, presence: true, uniqueness: true

  def self.get_new_apps(ref)
    AppScraper.new.scrape_app_details(ref)
  end

end
