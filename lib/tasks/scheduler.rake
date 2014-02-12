require 'app_scraper'

desc "This task is called by the Heroku scheduler add-on"
task :scrape => :environment do
  puts "Scraping..."
  type, year, from_ref, to_ref = 'P', '2014', '0007', '0007'
  AppScraper.new.get_new_apps(type, year, from_ref, to_ref)
  puts "Done!"
end
