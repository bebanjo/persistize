# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{persistize}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sergio Gil", "Luismi Cavall\303\251"]
  s.date = %q{2009-05-22}
  s.email = %q{ballsbreaking@bebanjo.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "MIT-LICENSE",
     "README.rdoc",
     "Rakefile",
     "init.rb",
     "lib/persistize.rb",
     "persistize.gemspec",
     "test/models/company.rb",
     "test/models/person.rb",
     "test/models/project.rb",
     "test/models/task.rb",
     "test/persistize_test.rb",
     "test/test_helper.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/bebanjo/persistize}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Easy denormalization for your ActiveRecord models}
  s.test_files = [
    "test/models/company.rb",
     "test/models/person.rb",
     "test/models/project.rb",
     "test/models/task.rb",
     "test/persistize_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
