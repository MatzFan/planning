Dir.glob("./lib/*.*").each {|file| require file }

class AppScraper

  URL_ROOT = 'https://www.mygov.je/Planning/Pages/PlanningApplication'
  PROPERTY_TAG_ID = 'ApplicationAddress" style="margin-top: 50px">'
  PARISHES = ['St. Helier','St. Brelade','Trinity','St. Clement','St. Peter',
              'St. Saviour','St. Martin','St. Mary','St. Ouen','Grouville',
              'St. John','St. Lawrence']

  def get_new_apps(type, year, from_ref, to_ref)
    (from_ref..to_ref).each do |app_number|
      details_page = source_for("#{type}/#{year}/#{app_number}", 'Detail')
      timelines_page = source_for("#{type}/#{year}/#{app_number}", 'Timeline')
      begin
        write_data(details_page, timelines_page) unless invalid? details_page
      rescue
        puts "Error with application: #{type}/#{year}/#{app_number}"
      end
    end
  end

  def write_data(details, timelines)
    parser = AppParser.new
    data = parser.parse_details_for(details)
    data['PlanningApp'].merge! parser.parse_timelines_for(timelines)
    new_app = PlanningApp.new(data['PlanningApp'])
    write_constraints(data['Constraints'].values[0], new_app)
    write_parish(data['Parish'].values[0], new_app)
    %w[PlanningApp Constraints Parish].each {|t| data.reject! { |k,v| k == t }}
    write_other_parent_table_data(data, new_app)
    new_app.save
  end

  def write_parish(parish_string, new_app)
    p_string = parish_string.downcase.gsub(/\s+/, '').gsub('.','')
    parish = PARISHES.select { |p| p.downcase.gsub('. ','') == p_string }[0]
    Parish.find_or_create_by(name: parish).planning_apps << new_app
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

  def invalid?(page)
    page.include?('An unexpected error has occurred') || blank?(page)
  end

  def blank?(page_source)
    tag = page_source.split(PROPERTY_TAG_ID).last.split('<').first.empty?
  end

  def source_for(app_ref, type)
    app_url = "#{URL_ROOT}#{type}.aspx?s=1&r=" + app_ref
    source = `curl -s 1 "#{app_url}"` # -s 1 suppresses progress bar
  end

end # of class
