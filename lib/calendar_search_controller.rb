require 'event'

class CalendarSearchController
  attr_reader :events
  
  def index(params)
    case params[:timeframe]
    when 'tomorrow'
      date = DateTime.now + 1
      start_date = date.at_beginning_of_day
      end_date =  start_date.end_of_day
    when 'this_week'
      start_date = DateTime.now
      end_date = (DateTime.now + 6 ).end_of_day
    when 'custom'
      start_date = params[:start_date].blank? ? DateTime.now.beginning_of_week : DateTime.strptime(params[:start_date], '%m/%d/%Y')
      end_date = params[:end_date].blank? ? (DateTime.now.end_of_week - 2) : DateTime.strptime(params[:end_date], '%m/%d/%Y').end_of_day
    when 'hour'
      start_date = DateTime.strptime(params[:hour], '%m/%d/%Y %H:%M')
      end_date =  start_date + 1.hour-1.second
    when 'today'
      date = DateTime.now
      start_date = date.at_beginning_of_day
      end_date =  start_date.end_of_day
    end
    
    @events = Event.between_dates(start_date, end_date)
  end
end