desc "This task is called by the Heroku scheduler add-on"
task :scrape => :environment do
  puts "Scraping..."
  from_ref = 'P/2014/0179'
  to_ref = 'P/2014/0179'
  PlanningApp.get_new_apps(from_ref, to_ref)
  puts "Done!"
end
