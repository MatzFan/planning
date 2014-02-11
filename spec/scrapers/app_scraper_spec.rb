require 'spec_helper'
require 'app_scraper'
require 'app_parser'

describe AppScraper do

  let(:scraper) { AppScraper.new }
  let(:valid_app_file) {'./spec/parsers/ValidPlanningApp.html'}
  let(:html_escaped_chars_app_file) { './spec/parsers/HTMLEscapeCharacters.html' }
  let(:dodgy_parish_app_file) {'./spec/parsers/DodgyParish.html'}

  context "#get_new_apps" do

      specify "should populate database with an (inclusive) range of apps" do
        scraper.get_new_apps('P', '2014', '0180', '0181')
        expect(PlanningApp.first.reference).to eq('P/2014/0180')
        expect(PlanningApp.last.reference).to eq('P/2014/0181')
      end

      specify "should skip pages for duff application references" do
        scraper.get_new_apps('P', '2014', '0181', '0182')
        expect(PlanningApp.count).to eq(1)
      end

      specify "should skip applications where property is blank" do
        scraper.get_new_apps('P', '2014', '0046', '0047')
        expect(PlanningApp.count).to eq(1)
      end

    end # of context

    context "#write_data_for" do

      specify "should correctly parse html escaped characters" do
        scraper.write_data_for(File.read(html_escaped_chars_app_file))
        expect(AppRoad.last.name).to eq("Parcq de l'Oeillere")
        expect(AgentName.last.name).to eq("Dyson & Buesnel Limited")
      end

      specify "should correctly identify mistyped Parish name" do
        scraper.write_data_for(File.read(dodgy_parish_app_file))
        expect(Parish.last.name).to eq("St. Martin")
      end

      specify "should populate correct fields" do
        field_contents = {reference: 'P/2014/0179',
                          description: 'Extend play and parking areas.',
                          applicant: 'Mr A Norman, La Route du Port Elizabeth,'+
                                      ' St. helier, JE2 3NW',
                          app_property: 'Mont Nicolle School',
                          latitude: 49.189235,
                          longitude: -2.187947}
        scraper.write_data_for(File.read(valid_app_file))
        field_contents.each do |key, value|
          expect(PlanningApp.last.send(key)).to eq(value)
        end
      end

      specify "should populate correct FK's" do
        constraints = ['Built-Up Area', 'Protected Open Space']
        scraper.write_data_for(File.read(valid_app_file))
        expect(PlanningApp.last.app_category.code).to eq('P')
        expect(PlanningApp.last.app_status.description).to eq('Pending')
        expect(PlanningApp.last.parish.name).to eq('St. Brelade')
        expect(PlanningApp.last.agent_name.name).to eq('Jersey Property Holdings')
        expect(PlanningApp.last.officer.name).to eq('Minor Team')
        expect(PlanningApp.last.app_road.name).to eq('La Route des Genets')
        expect(PlanningApp.last.app_postcode.code).to eq('JE3 8DB')
        constraints.each_with_index do |c, i|
          expect(PlanningApp.last.constraints[i].name).to eq constraints[i]
        end
      end

  end # of context

end # of describe
