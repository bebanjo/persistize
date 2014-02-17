require 'persistize/active_record'

module Persistize
  class Railtie < Rails::Railtie
    initializer "persistize" do |app|
      ActiveSupport.on_load :active_record do
        extend Persistize::ActiveRecord::ClassMethods
      end
    end
  end
end

