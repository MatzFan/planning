desc "This task is called by the Heroku scheduler add-on"
task :scrape => :environment do
  puts "Scraping..."
  PlanningApp.new_apps('P/2014/0180')
  puts "Done!"
end
