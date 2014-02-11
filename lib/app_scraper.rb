Dir.glob("./lib/*.*").each {|file| require file }

class AppScraper

  URL_ROOT = 'https://www.mygov.je/Planning/Pages/PlanningApplication'

  def get_new_apps(type, year, from_ref, to_ref)
    (from_ref..to_ref).each do |app_number|
      page_source = source_for("#{type}/#{year}/#{app_number}", 'Detail')
      write_data_for(page_source) unless invalid?(page_source)
    end
  end

  def write_data_for(page_source)
    parser = AppParser.new
    data = parser.parse_details_for(page_source)
    new_app = PlanningApp.new(reference: data[0],
                              applicant: data[4],
                              description: data[5],
                              app_property: data[6],
                              latitude: data[12],
                              longitude: data[13])

    AppCategory.find_or_create_by(code: data[1]).planning_apps << new_app
    AppStatus.find_or_create_by(description: data[2]).planning_apps << new_app
    Officer.find_or_create_by(name: data[3]).planning_apps << new_app
    AppRoad.find_or_create_by(name: data[7]).planning_apps << new_app
    Parish.find_or_create_by(name: data[8]).planning_apps << new_app
    AppPostcode.find_or_create_by(code: data[9]).planning_apps << new_app
    AgentName.find_or_create_by(name: data[11]).planning_apps << new_app
    parser.parse_constraints(data[10]).each do |c|
      Constraint.find_or_create_by(name: c).planning_apps << new_app
    end
    new_app.save
  end

  def invalid?(page_source)
    page_source.include?('An unexpected error has occurred')
  end

  def source_for(app_ref, type)
    app_url = "#{URL_ROOT}#{type}.aspx?s=1&r=" + app_ref
    source = `curl -s 1 "#{app_url}"` # -s 1 suppresses progress bar
  end

end # of module
