class Person < ActiveRecord::Base
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def initials
    "#{first_name.first}#{last_name.first}".upcase
  end
  
  persistize :full_name, :initials
  
end

# We need to declare the following classes exactly in this order to make the tests pass.
# TODO: Find out if the plugin works with a real Rails app where const_missing tries to find an unknown class

class Task < ActiveRecord::Base

end

class Project < ActiveRecord::Base
  has_many :tasks
  
  def completed?
    tasks.any? && tasks.all?(&:completed?)
  end
  
  persistize :completed?, :depending_on => :tasks
  
end