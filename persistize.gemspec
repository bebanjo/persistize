# -*- encoding: utf-8 -*-

$:.unshift File.expand_path('../lib', __FILE__)
require 'persistize/version'

Gem::Specification.new do |s|
  s.name = "persistize"
  s.version = Persistize::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sergio Gil", "Luismi Cavallé", "Paco Guzmán"]
  s.email = "ballsbreaking@bebanjo.com"
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = %w(init.rb MIT-LICENSE persistize.gemspec Rakefile README.rdoc) + Dir.glob("{test,lib/**/*}")
  s.homepage = "http://github.com/bebanjo/persistize"
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.6.2"
  s.summary = "Easy denormalization for your ActiveRecord models"
  s.specification_version = 3 if s.respond_to? :specification_version

  s.add_dependency("activerecord", ">= 3.1.0")

  s.add_development_dependency("shoulda")
  s.add_development_dependency("rake")
  s.add_development_dependency("rdoc")
  s.add_development_dependency("sqlite3")
end
