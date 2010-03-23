require 'test/unit'
require 'rubygems'
require 'shoulda'
require 'active_record'
require 'active_support'
require 'ruby-debug'

require File.dirname(__FILE__) + '/../init'

ActiveSupport::Dependencies.load_paths << File.dirname(__FILE__) + '/models'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Schema.verbose = false

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :people do |t|
      t.string :first_name, :last_name, :full_name, :initials, :info
      t.integer :company_id
    end
    create_table :projects do |t|
      t.string :name
      t.boolean :completed
      t.integer :person_id
    end
    create_table :tasks do |t|
      t.integer :project_id, :company_id
      t.boolean :completed
      t.string  :project_name
    end
    create_table :companies do |t|
      t.string :name, :summary
    end
    create_table :wadus_things do |t|
      t.string :summary
    end
    create_table :things do |t|
      t.integer :wadus_thing_id
      t.string :name
    end
  end
end

def drop_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

