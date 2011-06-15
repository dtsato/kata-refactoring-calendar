require 'event'

class CalendarSearchController
  attr_reader :events
  
  def index(params)
    scope = Event
    
    case params[:timeframe]
    when 'tomorrow'
      scope = scope.between_day(DateTime.now + 1)
    when 'this_week'
      scope = scope.between_dates(DateTime.now, ( DateTime.now + 6 ).end_of_day)
    when 'custom'
      if params[:start_date].blank?
        params[:start_date] = DateTime.now.beginning_of_week.to_s
      end
      if params[:end_date].blank?
        params[:end_date] = (DateTime.now.end_of_week - 2).to_s
      end
      scope = scope.between_dates(DateTime.parse(params[:start_date]), DateTime.parse(params[:end_date]).end_of_day)
    when 'hour'
      scope = scope.between_hour_on_day(DateTime.parse(params[:hour]))
    when 'today'
      scope = scope.between_day(DateTime.now)
    end
    
    @events = scope.all
  end
end