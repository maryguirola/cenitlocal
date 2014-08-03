module Dashboard
  class SalesController < BaseController
    before_action :get_orders, only: [:index, :by_week_days, :by_hours]
    before_action :get_comparison_orders, only: [:index, :by_week_days, :by_hours]
    
    def index
      time_line = {}
      @orders.each {|o| time_line[o.placed_on.to_time.to_s] = o.totals.order if o.totals } 
      
      time_line_compare = {}
      @comparison_orders.each {|o| time_line_compare[ o.placed_on + @diff] = o.totals.order if o.totals }       

      @time_line = [{:name => "#{@start_date} - #{@end_date}" ,:data => time_line },
                    {:name => "#{@comparison_start_date} - #{@comparison_end_date}", :data => time_line_compare }]

    end  
    
    def by_week_days
      @data = @orders.group_by{|o| o.placed_on.wday}.sort{|a,b| a[0]<=>b[0]}.collect{|c| [days[c[0]],compute(c[1])] }
    end
     
    def by_hours
      @data = @orders.group_by{|o| o.placed_on.hour}.sort{|a,b| a[0]<=>b[0]}.collect{|c| [hours[c[0]],compute(c[1])] }
    end
    
    def compute
      # Define in each class
    end   
    
    private
    
      def get_orders(options = {})
        @start_date = options[:start_date] ||= Date.today - 3.months
        @end_date = options[:end_date] ||= Date.today 
        @orders = Hub::Order.placed_on_between(options[:start_date], options[:end_date])
      end
      
      def get_comparison_orders(options = {})
        @comparison_start_date = options[:start_date] ||= Date.today - 6.months
        @comparison_end_date = options[:end_date] ||= Date.today - 3.months
        @diff =  (@start_date - @comparison_start_date).to_i.days
        @comparison_orders = Hub::Order.placed_on_between(options[:start_date], options[:end_date])
      end
      
  end
end