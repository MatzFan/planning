require 'cgi'

class AppParser

  DIV = '<span id="ctl00_SPWebPartManager1_g_cfcbb358_c3fe_4db2_9273_0f5e5f1320'+
        '83_ctl00_lbl'

  # mapping of database field-name_TableName and order each appears in page source
  FIELD_TABLE_DATA_MAP = {reference_PlanningApp: 'Reference',
                          code_AppCategories: 'Category',
                          description_AppStatus: 'Status',
                          name_Officer: 'Officer',
                          applicant_PlanningApp: 'Applicant',
                          description_PlanningApp: 'Description',
                          app_property_PlanningApp: 'ApplicationAddress',
                          name_AppRoad: 'RoadName',
                          name_Parish: 'Parish',
                          code_AppPostcode: 'PostCode',
                          name_Constraints: 'Constraints',
                          name_AgentName: 'Agent'}

  def table_name(symbol)
    symbol.to_s.split('_').last
  end

  def field_name(symbol)
    symbol[0..-(table_name(symbol).length + 2)]
  end

  def parse_details_for(source)
    app_details = {}
    table_data = source.split('pln-app')[1] # middle section of 3 is of interest
    table_string = table_data.split(DIV)
    parse_table_data(table_string, app_details)
    app_details['PlanningApp'].merge! Hash['latitude', parse_coord('Latitude', source)]
    app_details['PlanningApp'].merge! Hash['longitude', parse_coord('Longitude', source)]
    app_details
  end

  def parse_table_data(table_string, app_details)
    FIELD_TABLE_DATA_MAP.each_with_index do |(key, value), i|
      data = table_string[i + 1].split('<').first
      data_hash = Hash[field_name(key), parse_data_item(data, value)]
      if app_details[table_name(key)]
        app_details[table_name(key)].merge! data_hash
      else
        app_details[table_name(key)] = data_hash
      end
    end
  end

  def parse_data_item(data, value)
    tag = (value == 'ApplicationAddress' ? '" style="margin-top: 50px' : '')
    clean_html(data.split("#{value}#{tag}\">").last)
  end

  def clean_html(text)
    CGI.unescapeHTML(text)
  end

  def parse_coord(coord, source)
    coord = source.split("window.MapCentre#{coord} = ").last
    coord = coord.split(';').first
  end

end  # of class
