class Task < ActiveRecord::Base
  belongs_to :project
  
  def project_name
    project && project.name
  end
  
  persistize :project_name, :depending_on => :project
end