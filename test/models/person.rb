class Person < ActiveRecord::Base
  
  has_many :projects
  has_many :tasks, :through => :projects
  has_one :address
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def initials
    "#{first_name.first}#{last_name.first}".upcase
  end
  
  def info
    "#{full_name} has #{tasks.count} tasks in #{projects.count} projects"
  end
  
  def city_sentence
    address ? "#{first_name} lives in #{address.city}" : "#{first_name} hasn't told us where he lives"
  end
  
  persistize :full_name, :initials
  persistize :info, :depending_on => [:projects, :tasks]
  persistize :city_sentence, :depending_on => :address
end