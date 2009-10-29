class Project < ActiveRecord::Base
  has_many :tasks
  belongs_to :person
  
  def completed?
    tasks.any? && tasks.all?(&:completed?)
  end
  
  persistize :completed?, :depending_on => :tasks
end