require 'rspec'
require 'time_frame'

describe TimeFrame do
  before do
    @today = DateTime.strptime('06/01/2011', '%m/%d/%Y')
    DateTime.stub!(:now).and_return(@today)
  end

  describe "today's event" do
    it "should use beginning and end of day" do
      timeframe = TimeFrame.for('today', nil, nil, nil)

      timeframe.start_date.should == @today.at_beginning_of_day
      timeframe.end_date.should == @today.end_of_day
    end
  end

  describe "tomorrow's event" do
    it "should use beginning and end of tomorrow's day" do
      timeframe = TimeFrame.for('tomorrow', nil, nil, nil)

      tomorrow = @today + 1
      timeframe.start_date.should == tomorrow.at_beginning_of_day
      timeframe.end_date.should == tomorrow.end_of_day
    end
  end

  describe "this week's events" do
    it "should use 7 days period, starting today" do
      timeframe = TimeFrame.for('this_week', nil, nil, nil)

      timeframe.start_date.should == @today
      timeframe.end_date.should == (@today + 7.days) - 1.second
    end
  end

  describe "custom date range" do
    it "should return events for specified date range, using end of day for end date" do
      timeframe = TimeFrame.for('custom', '06/01/2010', '06/15/2010', nil)

      timeframe.start_date.should == DateTime.strptime('06/01/2010', '%m/%d/%Y')
      timeframe.end_date.should == DateTime.strptime('06/15/2010', '%m/%d/%Y').end_of_day
    end

    it "should default date range to this business week" do
      timeframe = TimeFrame.for('custom', nil, nil, nil)

      timeframe.start_date.should == @today.beginning_of_week
      timeframe.end_date.should == @today.end_of_week - 2.days
    end
  end

  describe "events for a specific hour" do
    it "should use 1 hour interval starting from given hour" do
      timeframe = TimeFrame.for('hour', nil, nil, "06/01/2010 15:00")

      hour = DateTime.strptime('06/01/2010 15:00', '%m/%d/%Y %H:%M')
      timeframe.start_date.should == hour
      timeframe.end_date.should == (hour + 1.hour) - 1.second
    end
  end
end