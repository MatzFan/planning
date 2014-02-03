require 'spec_helper'
require 'app_scraper'

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
        constraints = ['Built-Up Area', 'Core Retail Area',
                       'Potential Listed Building', 'Primary Route Network',
                       'Regeneration Zone', 'Town Centre', 'Town of St. Helier']
        AppScraper.new.get_new_apps('P', '2012', '0181', '0181')
        expect(PlanningApp.last.app_category.code).to eq('P')
        expect(PlanningApp.last.app_status.description).to eq('Approved')
        expect(PlanningApp.last.parish.name).to eq('St. Helier')
        expect(PlanningApp.last.agent_name.name).to eq('Currie & Brown (Consultants) Ltd')
        expect(PlanningApp.last.officer.name).to eq('Rebecca Hampson')
        expect(PlanningApp.last.app_road.name).to eq('Bath Street')
        expect(PlanningApp.last.app_postcode.code).to eq('JE2 4SU')
        constraints.each_with_index do |c, i|
          expect(PlanningApp.last.constraints[i].name).to eq constraints[i]
        end
      end

    end # of context

end # of describe
