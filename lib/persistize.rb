class ActiveRecord::Base

  def self.persistize(*args)
    
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
      
      define_method("#{attribute}=") do
        raise NoMethodError
      end

      before_save "update_#{attribute}"
      
      define_method("update_#{attribute}") do
        self[attribute] = send("#{attribute}_calculation")
        true # we need to return true to avoid canceling the save
      end

      if options && options[:depending_on]
        association = self.reflections[options[:depending_on]]
        me = self
        association.klass.class_eval do
          define_method("update_#{attribute}_in_parent") do
            parent = me.find(self[association.primary_key_name])
            parent.send("update_#{attribute}")
            parent.save!            
          end
          after_save "update_#{attribute}_in_parent"
          after_destroy "update_#{attribute}_in_parent"
        end
      end
      
    end
  end

end
