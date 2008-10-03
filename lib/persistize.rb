class ActiveRecord::Base

  def self.persistize(*methods)
    
    methods.each do |method|
      
      alias_method "#{method}_calculation", method
      
      define_method(method) do
        if new_record?
          send("#{method}_calculation")
        else
          self[method]
        end
      end
      
      define_method("#{method}=") do
        raise NoMethodError
      end

      before_save do |record|
        record[method] = record.send("#{method}_calculation")
      end
      
    end

  end

end
