require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the persistize plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the persistize plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Persistize'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "persistize"
    gemspec.authors = ["Sergio Gil", "Luismi Cavallé"]
    gemspec.email = "ballsbreaking@bebanjo.com"
    gemspec.homepage = "http://github.com/bebanjo/persistize"
    gemspec.summary = "Easy denormalization for your ActiveRecord models"
    gemspec.extra_rdoc_files = ["README.rdoc"]
  end
rescue LoadError
end