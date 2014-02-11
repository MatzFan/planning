Dir.glob("./lib/*.*").each {|file| require file }

class AppScraper

  URL_ROOT = 'https://www.mygov.je/Planning/Pages/PlanningApplication'

  PROPERTY_TAG_ID = 'ApplicationAddress" style="margin-top: 50px">'

  def get_new_apps(type, year, from_ref, to_ref)
    (from_ref..to_ref).each do |app_number|
      page = source_for("#{type}/#{year}/#{app_number}", 'Detail')
      write_data_for(page) unless (invalid?(page) || blank?(page))
    end
  end

  def write_data_for(page_source)
    data = AppParser.new.parse_details_for(page_source)
    new_app = PlanningApp.new(data['PlanningApp'])
    write_constraints(data['Constraints'].values[0], new_app)
    data.reject! { |k,v| k == 'PlanningApp' || k == 'Constraints' }
    write_other_parent_table_data(data, new_app)
    new_app.save
  end

  def write_constraints(constraints_string, new_app)
    constraints = constraints_string.split(',').map { |c| c.strip }
    constraints.each do |c|
      Constraint.find_or_create_by(name: c).planning_apps << new_app
    end
  end

  def write_other_parent_table_data(data, new_app)
    data.each do |table_name, field_data|
      table = table_name.classify.constantize
      table.send(:find_or_create_by, field_data).planning_apps << new_app
    end
  end

  def invalid?(page_source)
    page_source.include?('An unexpected error has occurred')
  end

  def blank?(page_source)
    tag = page_source.split(PROPERTY_TAG_ID).last.split('<').first.empty?
  end

  def source_for(app_ref, type)
    app_url = "#{URL_ROOT}#{type}.aspx?s=1&r=" + app_ref
    source = `curl -s 1 "#{app_url}"` # -s 1 suppresses progress bar
  end

end # of module
