class Person < ActiveRecord::Base
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def initials
    "#{first_name.first}#{last_name.first}".upcase
  end
  
  persistize :full_name, :initials
  
end

class Project < ActiveRecord::Base
  has_many :tasks
  
  def completed?
    tasks.all?(&:completed?)
  end
  
end

class Task < ActiveRecord::Base

end
