require 'spec_helper'

describe PlanningApp do

  context "::get_new_apps" do

    specify "should populate database with the application given" do
      PlanningApp.get_new_apps('P/2014/0180')
      expect(PlanningApp.first.reference).to eq('P/2014/0180')
    end

    specify "should skip pages for duff application references" do
      PlanningApp.get_new_apps('P/2014/0180')
      PlanningApp.get_new_apps('P/2014/9999')
      expect(PlanningApp.count).to eq(1)
    end
  end



end # of describe
