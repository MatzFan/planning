require 'app_scraper'

class PlanningApp < ActiveRecord::Base

  belongs_to :app_status

  validate :reference, presence: true, uniqueness: true

  def self.get_new_apps(from_ref, to_ref)
    AppScraper.new.scrape_app_details(from_ref, to_ref)
  end

end
