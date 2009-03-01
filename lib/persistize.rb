module Persistize
  module ClassMethods
    def persistize(*args)
      options = args.pop if args.last.is_a?(Hash)
    
      args.each do |method|
      
        attribute = method.to_s.sub(/\?$/, '')
      
        alias_method "#{attribute}_calculation", method
      
        define_method(method) do
          if new_record?
            send("#{attribute}_calculation")
          else
            self[attribute]
          end
        end

        before_save "update_#{attribute}"
      
        define_method("update_#{attribute}") do
          self[attribute] = send("#{attribute}_calculation")
          true # return true to avoid canceling the save
        end

        if options && options[:depending_on]
          dependencies = options[:depending_on].is_a?(Array) ? options[:depending_on] : [options[:depending_on]]
          dependencies.each do |dependency|
            association = self.reflections[dependency]
            me = self
            callback = "update_#{attribute}_in_#{me.to_s.underscore}"
            association.klass.class_eval do
              define_method(callback) do
                return true unless parent_id = self[association.primary_key_name]
                parent = me.find(parent_id)
                parent.send("update_#{attribute}")
                parent.save!            
              end
              after_save callback
              after_destroy callback
            end          
          end
        end
      
      end
    end
  end
end

ActiveRecord::Base.extend(Persistize::ClassMethods)