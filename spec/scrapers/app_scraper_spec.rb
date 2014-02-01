require 'spec_helper'

describe AppScraper do

  context "::get_new_apps" do

      specify "should populate database with an (inclusive) range of apps" do
        AppScraper.new.get_new_apps('P', '2014', '0180', '0181')
        expect(PlanningApp.first.reference).to eq('P/2014/0180')
        expect(PlanningApp.last.reference).to eq('P/2014/0181')
      end

      specify "should skip pages for duff application references" do
        AppScraper.new.get_new_apps('P', '2014', '0181', '0182')
        expect(PlanningApp.count).to eq(1)
      end

      specify "should populate correct fields" do
        field_contents = {reference: 'P/2014/0179',
                          description: 'Extend play and parking areas.',
                          applicant: 'Mr A Norman, La Route du Port Elizabeth,'+
                                      ' St. helier, JE2 3NW',
                          app_property: 'Mont Nicolle School',
                          latitude: 49.189235,
                          longitude: -2.187947}
        AppScraper.new.get_new_apps('P', '2014', '0179', '0179')
        field_contents.each do |key, value|
          expect(PlanningApp.last.send(key)).to eq(value)
        end
      end

      specify "should populate correct FK's" do
        AppScraper.new.get_new_apps('P', '2012', '0181', '0181')
        expect(PlanningApp.last.app_category.code).to eq('P')
        expect(PlanningApp.last.app_status.description).to eq('Approved')
        expect(PlanningApp.last.parish.name).to eq('St. Helier')
        expect(PlanningApp.last.agent_name.name).to eq('Currie & Brown (Consultants) Ltd')
      end

    end # of context

end
