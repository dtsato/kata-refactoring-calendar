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
        params[:start_date] = DateTime.now.beginning_of_week.strftime('%m/%d/%Y')
      end
      if params[:end_date].blank?
        params[:end_date] = (DateTime.now.end_of_week - 2).strftime('%m/%d/%Y')
      end
      scope = scope.between_dates(DateTime.strptime(params[:start_date], '%m/%d/%Y'), DateTime.strptime(params[:end_date], '%m/%d/%Y').end_of_day)
    when 'hour'
      scope = scope.between_hour_on_day(DateTime.strptime(params[:hour], '%m/%d/%Y %H:%M'))
    when 'today'
      scope = scope.between_day(DateTime.now)
    end
    
    @events = scope.all
  end
end