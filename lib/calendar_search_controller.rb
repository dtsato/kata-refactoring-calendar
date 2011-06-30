require 'event'
require 'time_frame'

class CalendarSearchController
  attr_reader :events
  
  def index(params)
    timeframe = TimeFrame.for(params[:timeframe], params[:start_date], params[:end_date], params[:hour])
    @events = Event.between_dates(timeframe.start_date, timeframe.end_date)
  end
end