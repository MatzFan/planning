class AppScraper

  URL_ROOT = 'https://www.mygov.je/Planning/Pages/PlanningApplication'

  DIV = '<span id="ctl00_SPWebPartManager1_g_cfcbb358_c3fe_4db2_9273_0f5e5f1320'+
        '83_ctl00_lbl'

  ITEMS = %w[Reference Category Status Officer Applicant Description
           ApplicationAddress RoadName Parish PostCode Constraints Agent]

  def scrape_app_details(ref)
    page_source = source_for(ref, 'Detail')
    if valid_application?(ref)
      data = parse_details_for(page_source)
      PlanningApp.create(reference: data[0], description: data[5])
    end
  end

  def valid_application?(page_source)
    page_source.include?('P/2014/0180')
  end

  def source_for(app_ref, type)
    app_url = "#{URL_ROOT}#{type}.aspx?s=1&r=" + app_ref
    source = `curl "#{app_url}"`
  end

  def parse_details_for(source)
    app_details = []
    table_data = source.split('pln-app')[1] # middle section of 3 is of interest
    table_split = table_data.split(DIV)
    ITEMS.each_with_index do |item, i|
      data = table_split[i + 1].split('<').first
      app_details << data.split('>').last
    end
    app_details << parse_coord('Latitude', source)
    app_details << parse_coord('Longitude', source)
  end

  def parse_coord(coord, source)
    coord = source.split("window.MapCentre#{coord} = ").last
    coord = coord.split(';').first
  end

end # of module
