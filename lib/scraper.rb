module Scraper

  def self.scrape(ref)
    PlanningApp.create(reference: ref)
  end

end # of module
