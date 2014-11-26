require 'spec_helper'
require 'app_scraper'
require 'app_parser'

describe AppScraper do

  let(:scraper) { AppScraper.new }
  let(:valid_app_file) { File.read('./spec/parsers/ValidPlanningApp.html') }
  let(:html_escaped_chars_app_file) { File.read('./spec/parsers/HTMLEscapeCharacters.html') }
  let(:dodgy_parish_app_file) { File.read('./spec/parsers/DodgyParish.html') }
  let(:app_timelines_file) { File.read('./spec/parsers/AppTimelines.html') }
  let(:empty_agent_file) { File.read('./spec/parsers/EmptyAgent.html') }
  let(:empty_parish_file) { File.read('./spec/parsers/BlankParish.html') }


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

      specify "should correctly parse timeline dates for an app" do
        scraper.get_new_apps('P', '2012', '0219', '0219')
        expect(PlanningApp.last.validated.to_formatted_s(:db)).to eq('2012-02-23')
        expect(PlanningApp.last.advertised.to_formatted_s(:db)).to eq('2012-02-28')
        expect(PlanningApp.last.end_publicity.to_formatted_s(:db)).to eq('2012-03-20')
        expect(PlanningApp.last.site_visited).to be_nil
        expect(PlanningApp.last.panel_ministerial).to be_nil
        expect(PlanningApp.last.decision.to_formatted_s(:db)).to eq('2012-04-18')
        expect(PlanningApp.last.appeal.to_formatted_s(:db)).to eq('2012-05-03')
      end

    end # of context

    context "#write_data" do

      specify "should correctly deal with empty agent field" do
        scraper.write_data(empty_agent_file, app_timelines_file)
        expect(AgentName.last.name).to be_nil
      end

      specify "should correctly deal with empty parish field" do
        scraper.write_data(empty_parish_file, app_timelines_file)
        expect(Parish.last).to be_nil
      end

      specify "should correctly parse html escaped characters" do
        scraper.write_data(html_escaped_chars_app_file, app_timelines_file)
        expect(AppRoad.last.name).to eq("Parcq de l'Oeillere")
        expect(AgentName.last.name).to eq("Dyson & Buesnel Limited")
      end

      specify "should correctly identify mistyped Parish name" do
        scraper.write_data(dodgy_parish_app_file, app_timelines_file)
        expect(Parish.last.name).to eq("St. Martin")
      end

      specify "should populate correct details fields" do
        field_contents = {reference: 'P/2014/0179',
                          description: 'Extend play and parking areas.',
                          applicant: 'Mr A Norman, La Route du Port Elizabeth,'+
                                      ' St. helier, JE2 3NW',
                          app_property: 'Mont Nicolle School',
                          latitude: 49.189235,
                          longitude: -2.187947}
        scraper.write_data(valid_app_file, app_timelines_file)
        field_contents.each do |key, value|
          expect(PlanningApp.last.send(key)).to eq(value)
        end
      end

      specify "should populate correct FK's" do
        constraints = ['Built-Up Area', 'Protected Open Space']
        scraper.write_data(valid_app_file, app_timelines_file)
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
