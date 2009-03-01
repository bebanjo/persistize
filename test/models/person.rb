class Person < ActiveRecord::Base
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def initials
    "#{first_name.first}#{last_name.first}".upcase
  end
  
  persistize :full_name, :initials
end