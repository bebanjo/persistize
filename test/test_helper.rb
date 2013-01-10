require "rubygems"
require "bundler/setup"

require 'test/unit'
require 'shoulda'
require 'sqlite3'
require 'active_record'
require 'active_support/all'
require 'ruby-debug'

require File.dirname(__FILE__) + '/../init'

ActiveSupport::Dependencies.autoload_paths << File.dirname(__FILE__) + '/models'

ActiveRecord::Base.configurations = {'test' => {:adapter => 'sqlite3', :database => ':memory:'}}
ActiveRecord::Base.establish_connection('test')

ActiveRecord::Schema.verbose = false

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :people do |t|
      t.string :first_name, :last_name, :full_name, :initials, :info, :city_sentence
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
    create_table :addresses do |t|
      t.integer :person_id
      t.string :city
    end
  end
end

def drop_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

