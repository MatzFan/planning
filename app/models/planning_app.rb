require 'app_scraper'

class PlanningApp < ActiveRecord::Base

  belongs_to :app_status
  belongs_to :app_category
  belongs_to :parish
  belongs_to :agent_name
  belongs_to :officer
  belongs_to :app_road
  belongs_to :app_postcode
  has_and_belongs_to_many :constraints

  validate :reference, presence: true, uniqueness: true

  def details_url
    "https://www.mygov.je//Planning/Pages/PlanningApplicationDetail.aspx?s=1&r=#{reference}"
  end

  search_syntax do # for dusen 'Google-like' search
    search_by :text do |scope, phrases|
      columns = [:description]
      scope.where_like(columns => phrases)
    end
  end

end
