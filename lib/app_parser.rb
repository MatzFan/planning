require 'cgi'

class AppParser

  DETAILS_DIV = '<span id="ctl00_SPWebPartManager1_g_4f066fb1_b1df_4e20_880a_6b578c53fe0e_ctl00_lbl'

  TIME_DIV = 'ctl00_SPWebPartManager1_g_849f47f2_9f27_42a4_9a38_42ded8266a36_ctl00_lbl'

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
      begin
        data_hash = Hash[field_name(key), parse_table_item(data, value)]
      rescue
        puts "Problem with parsing - app_details are:\n\n #{app_details.inspect}"
      end
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
    CGI.unescapeHTML(text) unless text.nil?
  end

  def parse_coord(coord, source)
    coord = source.split("window.MapCentre#{coord} = ").last
    coord = coord.split(';').first
  end

end  # of class
