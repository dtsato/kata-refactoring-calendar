require 'rspec'
require 'calendar_search_controller'

describe CalendarSearchController do
  before do
    @controller = CalendarSearchController.new
  end
  
  it "should create time frame from params and retrieve events" do
    timeframe = TimeFrame.new(DateTime.now, DateTime.now)
    TimeFrame.should_receive(:for).with('today', 'start', 'end', 'hour').and_return(timeframe)
    
    events = [Event.new, Event.new]
    Event.should_receive(:between_dates).with(timeframe.start_date, timeframe.end_date).and_return(events)
    
    @controller.index(:timeframe => 'today', :start_date => 'start', :end_date => 'end', :hour => 'hour')

    @controller.events.should == events
  end
end