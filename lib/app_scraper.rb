Dir.glob("./lib/*.*").each {|file| require file }

class AppScraper

  URL_ROOT = 'https://www.mygov.je/Planning/Pages/PlanningApplication'

  def get_new_apps(type, year, from_ref, to_ref)
    (from_ref..to_ref).each do |app_number|
      page_source = source_for("#{type}/#{year}/#{app_number}", 'Detail')
      write_data_for(page_source) unless invalid_application?(page_source)
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
    category = AppCategory.find_or_create_by(code: data[1])
    category.planning_apps << new_app
    status = AppStatus.find_or_create_by(description: data[2])
    status.planning_apps << new_app
    officer = Officer.find_or_create_by(name: data[3])
    officer.planning_apps << new_app
    road = AppRoad.find_or_create_by(name: data[7])
    road.planning_apps << new_app
    parish = Parish.find_or_create_by(name: data[8])
    parish.planning_apps << new_app
    postcode = AppPostcode.find_or_create_by(code: data[9])
    postcode.planning_apps << new_app

    populate(new_app, parser.parse_constraints(data[10]))

    agent = AgentName.find_or_create_by(name: data[11])
    agent.planning_apps << new_app
    new_app.save
  end

  def populate(app, constraints)
    constraints.each do |c|
      constraint = Constraint.find_or_create_by(name: c)
      app.constraints << constraint
    end
  end

  def invalid_application?(page_source)
    page_source.include?('An unexpected error has occurred')
  end

  def source_for(app_ref, type)
    app_url = "#{URL_ROOT}#{type}.aspx?s=1&r=" + app_ref
    source = `curl "#{app_url}"`
  end

end # of module
