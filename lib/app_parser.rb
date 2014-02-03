require 'cgi'

class AppParser

  DIV = '<span id="ctl00_SPWebPartManager1_g_cfcbb358_c3fe_4db2_9273_0f5e5f1320'+
        '83_ctl00_lbl'

  # mapping of database field-name_TableName and order each appears in page source
  FIELD_TABLE_DATA_MAP = {reference_PlanningApp: 'Reference',
                          code_AppCategory: 'Category',
                          description_AppStatus: 'Status',
                          name_Officer: 'Officer',
                          applicant_PlanningApp: 'Applicant',
                          description_PlanningApp: 'Description',
                          app_property: 'ApplicationAddress',
                          name_AppRoad: 'RoadName',
                          name_Parish: 'Parish',
                          code_AppPostcode: 'PostCode',
                          name_Constraints: 'Constraints',
                          name_AgentName: 'Agent'}

  def field(map_item)
    map_item.value.spilt('_').first
  end

  def table(map_item)
    map_item.value.spilt('_').last
  end

  def parse_details_for(source)
    app_details = []
    table_data = source.split('pln-app')[1] # middle section of 3 is of interest
    table_split = table_data.split(DIV)
    FIELD_TABLE_DATA_MAP.each_with_index do |(key, value), i|
      data = table_split[i + 1].split('<').first
      app_details << parse_data_item(data, value)
    end
    app_details << parse_coord('Latitude', source)
    app_details << parse_coord('Longitude', source)
  end

  def parse_data_item(data, value)
    tag = (value == 'ApplicationAddress' ? '" style="margin-top: 50px' : '')
    clean_html(data.split("#{tag}\">").last)
  end

  def clean_html(text)
    CGI.unescapeHTML(text)
  end

  def parse_coord(coord, source)
    coord = source.split("window.MapCentre#{coord} = ").last
    coord = coord.split(';').first
  end

  def parse_constraints(string)
    constraints = string.split(',').map { |c| c.strip }
  end

end  # of class
