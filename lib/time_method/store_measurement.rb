module TimeMethod
  class StoreMeasurement
    include Singleton
    def initialize
      @time_for_method     = []
      @methods_in_order    = []
      @depth               = 0
      @full_stack         = []
    end   

    def add_to_stack(in_or_out,klass_name,method_name)
      @depth+=1 if in_or_out == "in"
      @depth-=1 if in_or_out == "out"
      mod_klass_name=klass_name.split("::").last
      name="#{mod_klass_name}.#{method_name}"
    end 
    
    # can add some logic here when/while storing as well
    def store(klass_name:,method_name:,time:)
      mod_klass_name=klass_name.split("::").last
      name="#{mod_klass_name}.#{method_name}"
      @time_for_method.push([name,time,@depth])
    end 

    def make_summary_arr(sort_by:)
      updated_time_for_method = @time_for_method.map{|x| [x[0],(x[1].real*1000).round(2),"   "*x[2]]}
      h=updated_time_for_method.group_by{|a| a[0]}
      new_h={}
      h.each do |k,v|
        sum = 0
        count=0
        v.each do |el|
          sum+=el[1]
          count+=1
        end   
        avg = (sum/count)
        tabs = v[0][2]
        new_h[k]=[sum,count,avg,tabs]
      end 
      new_arr=[]    
      new_h.each do |k,v|
        k_with_tabs = v[3]+k
        method_and_class_name=k_with_tabs.scan(/[a-zA-Z::_0-9\t ]+/)
        new_arr.push([*method_and_class_name,*v])
      end

      if sort_by == "run_time"
        new_arr.map! {|x| [x[0].gsub(" ",""),x[1],x[2].round(0),x[3].round(0),x[4].round(0)]}
        new_arr.sort! {|a,b| b[2] <=> a[2]}
        title = "Sorted List of Methods By Total Run Time"
      elsif sort_by == "execution_order"
        new_arr.map! {|x| [x[0],x[1],x[2].round(0),x[3].round(0),x[4].round(0)]}
        new_arr = new_arr.reverse
        title = "Sorted List of Methods By Total Execution Order"
      end 
      
      headings=[ "Class Name", "Method Name", "Total Run Time (ms)","# of Calls","Average Time Per Call (ms)"] 
      table = Terminal::Table.new :title => title ,:headings => headings do |t|
        t.rows = new_arr
      end 
      return table
    end 

    def make_summary_arr_run_time
      @summary_arr = make_summary_arr(sort_by:"run_time")
    end 

    def print_summary_arr_run_time
      puts @summary_arr
    end 
    

    def make_summary_arr_execution_order
      @summary_arr_execution_order = make_summary_arr(sort_by:"execution_order")
    end 

    def print_summary_arr_execution_order
      puts @summary_arr_execution_order
    end 

    def print_summary_arr
      puts @summary_arr
    end 

    def print_all
      make_summary_arr_run_time
      make_summary_arr_execution_order
      print_summary_arr_run_time
      print_summary_arr_execution_order
      @time_for_method=[]
    end
  end
end
