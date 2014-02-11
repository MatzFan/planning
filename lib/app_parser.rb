require 'cgi'

class AppParser

  DETAILS_DIV = '<span id="ctl00_SPWebPartManager1_g_cfcbb358_c3fe_4db2_9273_'+
                '0f5e5f132083_ctl00_lbl'
  TIME_DIV = 'ctl00_SPWebPartManager1_g_eb24f5d8_516c_4120_9f29_512444e2187a_'+
             'ctl00_lbl'

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

  DATES_MAP = {validated: 'ValidDate',
               advertised: 'AdvertisedDate',
               end_publicity: 'endpublicityDate',
               site_visited: 'SitevisitDate',
               panel_ministerial: 'CommitteeDate',
               decision: 'Decisiondate',
               appeal: 'Appealdate'}

  def table_name(symbol)
    symbol.to_s.split('_').last
  end

  def field_name(symbol)
    symbol[0..-(table_name(symbol).length + 2)]
  end

  def parse_timelines_for(source)
    app_timelines = {}
    DATES_MAP.each_with_index do |(key, value), i|
      data = source.split(TIME_DIV)[i + 2].split('<').first
      # data_hash = Hash[key, parse_table_item(data, value)]
      app_timelines[key] = parse_table_item(data, value)
    end
    app_timelines
  end

  def parse_details_for(source)
    app_details = {}
    table_string = parse_details_table(source)
    parse_details(table_string, app_details)
    app_details['PlanningApp'].merge! Hash['latitude', parse_coord('Latitude', source)]
    app_details['PlanningApp'].merge! Hash['longitude', parse_coord('Longitude', source)]
    app_details
  end

  def parse_details(table_string, app_details)
    FIELD_TABLE_DATA_MAP.each_with_index do |(key, value), i|
      data = table_string[i + 1].split('<').first
      data_hash = Hash[field_name(key), parse_table_item(data, value)]
      if app_details[table_name(key)]
        app_details[table_name(key)].merge! data_hash
      else
        app_details[table_name(key)] = data_hash
      end
    end
  end

  def parse_details_table(source)
    table_data = source.split('pln-app')[1] # middle section of 3 is of interest
    table_data.split(DETAILS_DIV)
  end

  def parse_table_item(data, value)
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
