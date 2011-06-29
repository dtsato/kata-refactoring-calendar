require 'rspec'
require 'event'

describe Event do
  describe "between_hour_on_day" do
    before do
      @event_beginning_of_hour = Event.create(:at => DateTime.strptime("02/16/2010 13:00:00", "%m/%d/%Y %H:%M:%S"))
      @event_end_of_hour = Event.create(:at => DateTime.strptime("02/16/2010 13:59:59", "%m/%d/%Y %H:%M:%S"))
      @after_event = Event.create(:at => DateTime.strptime("02/16/2010 14:00:00", "%m/%d/%Y %H:%M:%S"))
    end

    it "should return an event at the beginning of the hour" do
      Event.between_hour_on_day(DateTime.strptime("02/16/2010 13:00", "%m/%d/%Y %H:%M")).should include(@event_beginning_of_hour)
    end

    it "should return an event at the end of the hour" do
      Event.between_hour_on_day(DateTime.strptime("02/16/2010 13:00", "%m/%d/%Y %H:%M")).should include(@event_end_of_hour)
    end

    it "should not return an event after the hour window" do
      Event.between_hour_on_day(DateTime.strptime("02/16/2010 13:00", "%m/%d/%Y %H:%M")).should_not include(@after_event)
    end
  end

  describe "between_day" do
    before do
      @event_midnight = Event.create(:at => DateTime.strptime("02/16/2010", "%m/%d/%Y"))
      @event_midday = Event.create(:at => DateTime.strptime("02/16/2010 13:00:00", "%m/%d/%Y %H:%M:%S"))
      @event_midnight_tomorrow = Event.create(:at => DateTime.strptime("02/17/2010", "%m/%d/%Y"))
    end

    it "should return an event at the beginning of the day" do
      Event.between_day(DateTime.strptime("02/16/2010", "%m/%d/%Y")).should include(@event_midday)
    end
    it "should return an event at midnight today" do
      Event.between_day(DateTime.strptime("02/16/2010", "%m/%d/%Y")).should include(@event_midnight)
    end
    it "should not return an event at midnight tomorrow" do
      Event.between_day(DateTime.strptime("02/16/2010", "%m/%d/%Y")).should_not include(@event_midnight_tomorrow)
    end
  end

  describe "between_dates" do
    it "should return events for a given date range" do
      today = DateTime.now
      start_date = DateTime.strptime('06/01/2010', "%m/%d/%Y")
      end_date = DateTime.strptime('06/15/2010', "%m/%d/%Y")

      events = [Event.create(:at => start_date), Event.create(:at => start_date + 3), Event.create(:at => end_date - 1)]
      more_events = [Event.create(:at => start_date - 2), Event.create(:at => start_date - 1)]
      Event.between_dates(start_date, end_date.end_of_day).should == events
    end      
  end
  
end