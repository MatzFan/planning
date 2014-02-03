class AppParser

  DIV = '<span id="ctl00_SPWebPartManager1_g_cfcbb358_c3fe_4db2_9273_0f5e5f1320'+
        '83_ctl00_lbl'

  ITEMS = %w[Reference Category Status Officer Applicant Description
           ApplicationAddress RoadName Parish PostCode Constraints Agent]

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

  def parse_constraints(string)
    constraints = string.split(',').map { |c| c.strip }
  end

end  # of class
