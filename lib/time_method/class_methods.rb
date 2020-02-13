load "#{Rails.root}/lib/time_method/store_measurement.rb"
module TimeMethod
  module ClassMethods

    def time_method_name
      name.gsub("::","_")
    end 

    def tracked_instance_methods(*method_names)
      method_names.each do |method_name|
        add_method_to_interceptor(instance_interceptor,method_name)
      end 
    end 

    def tracked_class_methods(*method_names)
      method_names.each do |method_name|
        add_method_to_interceptor(class_interceptor,method_name)
      end 
    end 
    def tracked_private_instance_methods(*method_names)
      tracked_instance_methods(*method_names)
      method_names.each { |method_name| private_interceptor_method(instance_interceptor,method_name)}
    end

    def tracked_private_class_methods(*method_namess)
      tracked_class_methods(*method_names)
      method_names.each { |method_name| private_interceptor_method(class_interceptor,method_name)}
    end

    def privatize_interceptor_method(interceptor,method_name)
      interceptor.class_eval {private method_name}
    end 

    def instance_interceptor
      const_get("#{time_method_name}InstanceInterceptor")
    end 

    def class_interceptor
      const_get("#{time_method_name}ClassInterceptor")
    end 

    def add_method_to_interceptor(interceptor,method_name)
      interceptor.class_eval do
        define_method method_name do |*args, &block|
          TimeMethod.measure(klass_name:interceptor.klass_name.to_s,method_name:method_name.to_s) do
            super(*args,&block)
          end 
        end 
      end 
    end 
  end
end 