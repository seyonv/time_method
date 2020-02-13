require_relative "lib/class_methods"
require_relative "lib/configuration"
require_relative "lib/measurement"

module TimeMethod
  class << self

    def configure
      yield(configuration)
    end 

    def measure(klass_name: nil, method_name: nil)
      t0 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      StoreMeasurement.instance.add_to_stack(
        "in",klass_name,method_name
        )
      block_return_value = yield if block_given?
      StoreMeasurement.instance.add_to_stack(
        "out", klass_name, method_name
      )
      t1 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      begin
        measurement = TimeMethod::Measurement.new(
          klass_name: klass_name.to_s, 
          method_name: method_name.to_s,
          t0: t0, 
          t1: t1
        )
      rescue => e
        puts  e,e.backtrace[0..3]
      end

      block_return_value
    end

    def print_all_run_times
      StoreMeasurement.instance.print_all
    end 

    def configuration
      @configuration ||= Configuration.new
    end 

    def included(base_class)
      base_class.extend ClassMethods
      # below creates two modules and then makes
      # them accessible through a constant name
      instance_interceptor = const_set(
        instance_interceptor_name_for(base_class),
        interceptor_module_for(base_class)
      )
      class_interceptor = const_set(
        class_interceptor_name_for(base_class),
        interceptor_module_for(base_class)
      )

      return unless should_run_and_time_methods?

      base_class.prepend instance_interceptor
      base_class.singleton_class.prepend class_interceptor
    end 

    def instance_interceptor_name_for(base_class)
      "#{base_class.time_method_name}InstanceInterceptor"
    end 

    def class_interceptor_name_for(base_class)
      "#{base_class.time_method_name}ClassInterceptor"
    end 


    def interceptor_module_for(base_class)
      Module.new do 
        @klass_name = base_class
        def self.klass_name
          @klass_name
        end 
      end
    end 

    def should_run_and_time_methods?
      configuration.enable_time_method
    end 
  end 
end 