require 'app_scraper'

class PlanningApp < ActiveRecord::Base

  validate :reference, presence: true, uniqueness: true

  def self.new_apps(ref)
    AppScraper::scrape_app_details(ref)
  end

end
