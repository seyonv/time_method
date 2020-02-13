module TimeMethod
  class Measurement
    attr_accessor :klass_name, :method_name, :segment, :metadata, :t0, :t1,:time
    def initialize(klass_name:, method_name:, t0:, t1:)
      @klass_name  = klass_name
      @method_name = method_name
      @t0          = t0
      @t1          = t1
      # @time        = runtime_ms
      @time        = runtime_seconds
      store_measurement
    end 

    def store_measurement
      StoreMeasurement.instance.store(klass_name:@klass_name,method_name:@method_name,time:@time)
    end 

    def output_stack
      StoreMeasurement.instance.output_stack
    end 

    def runtime
      @runtime_in_milliseconds ||= ((@t1 - @t0) * 1000).round(2)
    end 

    def runtime_ms
      @runtime_in_milliseconds ||= ((@t1 - @t0) * 1000).round(2)
    end 

    def runtime_seconds
      @runtime_in_seconds ||= (@t1 - @t0).round(2)
    end 
  end
end