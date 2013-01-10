class Wadus::Thing < ActiveRecord::Base
  self.table_name = :wadus_things

  has_many :things, :class_name => "::Thing", :foreign_key => "wadus_thing_id"

  def summary
    things.map(&:name).join(", ")
  end
  persistize :summary, :depending_on => :things
end