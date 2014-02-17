module Persistize
end

if defined?(Rails::Railtie)
  require 'persistize/railtie'
elsif defined?(Rails::Initializer)
  raise "persistize is not compatible with Rails 2.3 or older"
end
