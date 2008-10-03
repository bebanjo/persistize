require 'test/unit'
require 'rubygems'
require 'shoulda'
require 'activerecord'
require 'activesupport'

require File.dirname(__FILE__) + '/../init'

class Project < ActiveRecord::Base
  has_many :tasks
  
  def completed?
    tasks.all?(&:completed?)
  end
  
end

class Task < ActiveRecord::Base

end

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :projects do |t|
      t.string :name
      t.boolean :completed
      t.string :hello
    end
    create_table :tasks do |t|
      t.integer :project_id
      t.boolean :completed
    end
  end
end

def drop_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end


class PersistizeTest < Test::Unit::TestCase
  
  context "A project which persistizes Project#hello" do
    
    setup do
      setup_db
      
      Project.class_eval do

        def hello
          @hello_value ||= 'hi'
        end
        
        def bye
          'bye'
        end
        
        persistize :hello, :bye
        
        attr_accessor :hello_value
      end
      
      @project = Project.create
    end
    
    should "update the value of hello in the database when created" do
      assert_equal('hi', @project[:hello])
      assert_equal(@project, Project.find_by_hello('hi'))
    end
    
    should "update the value of hello in the database when updated" do
      @project.hello_value = 'bye'
      @project.update_attributes!(:name => 'new name')
      assert_equal('bye', @project[:hello])
      assert_equal(@project, Project.find_by_hello('bye'))
    end    
    
    should "not call the method when reading after being saved" do
      @project.hello_value = 'gutten morgen'
      assert_equal('hi', @project.hello)
    end
    
    should "call the method when reading before being created" do
      project = Project.new
      assert_equal('hi', project.hello)
    end
    
    should "not be able to manually update hello" do
      assert_raise(NoMethodError) { @project.hello = 'Catacrock' }
    end
    
    should "also persistize #bye" do
      assert_equal('bye', @project[:bye])
    end
    
    teardown do
      drop_db
    end
    
  end
  
end
