Persistize
==========

Persistize is a Rails plugin for easy denormalization. It works just like `memoize` but it stores the value as an attribute in the database. You only need to write a method with the denormalization logic and a field in the database with the same name of the method. The field will get updated each time the record is saved:

    class Person < ActiveRecord::Base
    
      def full_name
        "#{first_name} #{last_name}"
      end
  
      persistize :full_name
    
    end
  
    ...
  
    Person.create(:first_name => 'Jimi', :last_name => 'Hendrix')
    Person.find_by_full_name('Jimi Hendrix') # #<Person id:1, first_name:"Jimi", last_name:"Hendrix", full_name:"Jimi Hendrix" ...>
  
Dependency
----------

Sometimes you want to update the field not when the record is changed, but when some other associated records are. For example:

    class Project < ActiveRecord::Base
      has_many :tasks
      
      def completed?
        tasks.any? && tasks.all?(&:completed?)
      end
      
      persistize :completed?, :depending_on => :tasks
      
      named_scope :completed, :conditions => { :completed => true }
      
    end
    
    class Task < ActiveRecord::Base
      belongs_to :project
    end
    
    ...
    
    project = Project.create(:name => 'Rails')
    task = project.tasks.create(:name => 'Make it scale', :completed => false)    
    Project.completed  # []
    
    task.update_attributes(:completed => true)
    Project.completed  # [#<Project id:1, name:"Rails", completed:true ...>]
    
You can add more than one dependency using an array:

    persistize :summary, :depending_on => [ :projects, :people, :tasks ]

These examples are just some of the possible applications of this pattern, your imagination is the limit =;-) If you can find better examples, please send them to us.

To-do
-----

* More kinds of dependencies (`belongs_to`, `has_one`, `has_many :through`)
* Make cache optional (cache can cause records to be inconsistent if changed and not saved so it would be nice to be able to deactivate it)
* Make it available also as a gem

Copyright (c) 2008 Luismi Cavallé & Sergio Gil, released under the MIT license