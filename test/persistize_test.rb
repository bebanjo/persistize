# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/test_helper'

class PersistizeTest < Test::Unit::TestCase
  
  context "Using persistize" do
  
    setup do
      setup_db
    end
  
    teardown do
      drop_db
    end
  
    context "a person" do
    
      setup do
        @person = Person.create(:first_name => "Jimi", :last_name => "Hendrix")
      end
    
      should "update the value of full name in the database when created" do
        assert_equal('Jimi Hendrix', @person[:full_name])
        assert_equal(@person, Person.find_by_full_name('Jimi Hendrix'))
      end
    
      should "update the value of full name in the database when updated" do
        @person.update_attributes!(:first_name => "Axl", :last_name => "Rose")
        assert_equal('Axl Rose', @person[:full_name])
        assert_equal(@person, Person.find_by_full_name('Axl Rose'))
      end    
    
      should "call the method when object is dirty" do
        @person.first_name = 'Axl'
        assert_equal('Axl Hendrix', @person.full_name)
      end
    
      should "call the method when reading before being created" do
        person = Person.new(:first_name => "Jimi", :last_name => "Hendrix")
        assert_equal('Jimi Hendrix', person.full_name)
      end
    
      should "also persistize #initials" do
        assert_equal('JH', @person[:initials])
      end
    
    end
  
    context "a project with tasks" do
    
      setup do
        @project = Project.create(:name => "Rails")
        @task = @project.tasks.create(:completed => true)
      end
      
      should "update @project#completed? when a new task is created" do
        Task.create(:project_id => @project.id, :completed => false)
        assert !@project.reload[:completed]
      end
    
      should "update @project#completed? when a task is deleted" do
        @task.destroy
        assert !@project.reload[:completed]
      end
      
      should "update @project#completed? when a task is updated" do
        @task.update_attributes!(:completed => false)
        assert !@project.reload[:completed]
      end
      
      should "update each task's #project_name when the project name is updated" do
        @project.update_attributes!(:name => "Merb")
        assert_equal "Merb", @task.reload[:project_name]
      end
    end
    
    context "a company with people and tasks" do
      
      setup do
        @company = Company.create(:name => "BeBanjo")
      end
      
      should "update summary when it is created" do
        assert_equal("BeBanjo has 0 people and 0 tasks", @company.reload[:summary])
      end
      
      should "update summary when a person is created" do
        @company.people.create(:first_name => 'Bruce', :last_name => 'Dickinson')
        assert_equal("BeBanjo has 1 people and 0 tasks", @company.reload[:summary])
      end
      
      should "update summary when a task created" do
        @company.tasks.create
        assert_equal("BeBanjo has 0 people and 1 tasks", @company.reload[:summary])
      end
      
    end
    
    context "a person with projects and tasks" do
      
      setup do
        @person = Person.create(:first_name => "Enjuto", :last_name => "Mojamuto")
        @project = Project.create(:name => "La Hora Chanante", :person => @person)
        Project.create(:name => "Wadus", :person => @person)
        3.times { Task.create(:project => @project) }
      end
      
      should "have info" do
        assert_equal("Enjuto Mojamuto has 3 tasks in 2 projects", @person.reload[:info])
      end
    end
    
    context "namespaced models" do
      
      should "access to namespaced models" do
        @thing = Wadus::Thing.create
        2.times { |i| @thing.things.create(:name => "Thing number #{i + 1}") }
        assert_equal("Thing number 1, Thing number 2", @thing.reload[:summary])
      end

    end
    
    context "a person with an address" do
      
      setup do
        @person = Person.create!(:first_name => "Tomas", :last_name => "Ujfalusi")
      end
      
      should "update city_sentence when person is created" do
        assert_equal "Tomas hasn't told us where he lives", @person[:city_sentence]
      end
      
      should "update city_sentence when address is created" do
        @person.create_address(:city => "Madrid")
        assert_equal "Tomas lives in Madrid", @person.reload[:city_sentence]
      end
      
      should "update city_sentence when address is updated" do
        @address = @person.create_address(:city => "Madrid")
        @address.update_attributes!(:city => "Tarancón")
        assert_equal "Tomas lives in Tarancón", @person.reload[:city_sentence]
      end
      
      should "update city_sentence when address is deleted" do
        @address = @person.create_address(:city => "Madrid")
        @address.destroy
        assert_equal "Tomas hasn't told us where he lives", @person.reload[:city_sentence]
      end
    end
  end
  
end
