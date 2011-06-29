require 'rspec'
require 'calendar_search_controller'

describe CalendarSearchController do
  around(:each) do |example|
    Event.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
  
  describe "searching based on date range" do
    before do
      @controller = CalendarSearchController.new
      @today = DateTime.strptime('06/01/2011', '%m/%d/%Y')
      DateTime.stub!(:now).and_return(@today)
    end
    
    it "should return today's events" do
      today_events = [Event.create(:at => @today), Event.create(:at => @today)]
      tomorrow = @today + 1
      
      tomorrow_events = [Event.create(:at => tomorrow), Event.create(:at => tomorrow)]
      
      @controller.index(:timeframe => 'today')

      @controller.events.should == today_events
    end
    
    it "should return tomorrow's events" do
      tomorrow = @today + 1
      tomorrow_events = [Event.create(:at => tomorrow), Event.create(:at => tomorrow)]
      more_events = [Event.create(:at => tomorrow - 2), Event.create(:at => tomorrow + 2)]
      
      @controller.index(:timeframe => 'tomorrow')
      
      @controller.events.should == tomorrow_events
    end
    
    it "should return this week's events" do
      events_this_week = [Event.create(:at => @today), Event.create(:at => @today + 3), Event.create(:at => @today + 6)]
      more_events = [Event.create(:at => @today + 12), Event.create(:at => @today - 10)]
      
      @controller.index :timeframe => 'this_week'
      @controller.events.should == events_this_week        
    end

    it "should return events for specified date range" do
      start_date = DateTime.strptime('06/01/2010', '%m/%d/%Y')
      end_date = DateTime.strptime('06/15/2010', '%m/%d/%Y')

      events = [Event.create(:at => start_date), Event.create(:at => start_date + 3), Event.create(:at => end_date - 1)]
      more_events = [Event.create(:at => start_date - 2), Event.create(:at => start_date - 1)]
      @controller.index :timeframe => 'custom', :start_date => '06/01/2010', :end_date => '06/15/2010'
      @controller.events.should == events
    end

    it "should default date range to this business week" do
      wednesday = @today
      events_this_week = [Event.create(:at => wednesday), Event.create(:at => wednesday - 2), Event.create(:at => wednesday + 2)]
      more_events = [Event.create(:at => wednesday + 3), Event.create(:at => wednesday - 3)]
      
      @controller.index :timeframe => 'custom'
      @controller.events.should == events_this_week
    end

    it "returns events for a specified hour" do
      hour = DateTime.strptime('06/01/2010 15:00', '%m/%d/%Y %H:%M')

      events = [Event.create(:at => hour), Event.create(:at => hour + 1.second), Event.create(:at => hour + 1.minute)]
      Event.create(:at => hour + 1.hour); Event.create(:at => hour - 1.hour); Event.create(:at => hour - 1.day)
      @controller.index :timeframe => 'hour', :hour => "06/01/2010 15:00" 
      @controller.events.should == events
    end
  end
  
end