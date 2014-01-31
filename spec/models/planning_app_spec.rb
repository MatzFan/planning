require 'spec_helper'

describe PlanningApp do

  context "::scrape" do
    specify "should populate database with the application given" do
      expect(PlanningApp.count).to eq(0)
      PlanningApp.new_apps('P/2014/0180')
      expect(PlanningApp.first.reference).to eq('P/2014/0180')
    end
  end

end # of describe
