require 'test/unit'
require 'rubygems'
require 'shoulda'
require 'activerecord'
require 'activesupport'

require File.dirname(__FILE__) + '/../init'

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

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :people do |t|
      t.string :first_name, :last_name, :full_name, :initials
    end
    create_table :projects do |t|
      t.string :name
      t.boolean :completed
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
  
  context "A person" do
    
    setup do
      setup_db
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
    
    should "not update the calculated value until saved" do
      @person.first_name = 'Axl'
      assert_equal('Jimi Hendrix', @person.full_name)
      # TODO: Rethink this behaviour. Do we want to cache or not?
    end
    
    should "call the method when reading before being created" do
      person = Person.new(:first_name => "Jimi", :last_name => "Hendrix")
      assert_equal('Jimi Hendrix', person.full_name)
    end
    
    should "not be able to manually update hello" do
      assert_raise(NoMethodError) { @person.full_name = 'Catacrock' }
    end
    
    should "also persistize #initials" do
      assert_equal('JH', @person[:initials])
    end
    
    teardown do
      drop_db
    end
    
  end
  
end
