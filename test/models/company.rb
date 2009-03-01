class Company < ActiveRecord::Base
  has_many :people
  has_many :tasks
  
  def summary
    "#{name} has #{people.count} people and #{tasks.count} tasks"
  end
  
  persistize :summary, :depending_on => [ :people, :tasks ]
end