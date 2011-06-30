require 'rspec'
require 'time_frame'

describe TimeFrame do
  before do
    @today = DateTime.strptime('06/01/2011', '%m/%d/%Y')
    DateTime.stub!(:now).and_return(@today)
  end

  describe TimeFrame::Today do
    it "should use beginning and end of day" do
      timeframe = TimeFrame::Today.new

      timeframe.start_date.should == @today.at_beginning_of_day
      timeframe.end_date.should == @today.end_of_day
    end
  end

  describe TimeFrame::Tomorrow do
    it "should use beginning and end of tomorrow's day" do
      timeframe = TimeFrame::Tomorrow.new

      tomorrow = @today + 1
      timeframe.start_date.should == tomorrow.at_beginning_of_day
      timeframe.end_date.should == tomorrow.end_of_day
    end
  end

  describe TimeFrame::ThisWeek do
    it "should use 7 days period, starting today" do
      timeframe = TimeFrame::ThisWeek.new

      timeframe.start_date.should == @today
      timeframe.end_date.should == (@today + 7.days) - 1.second
    end
  end

  describe TimeFrame::Custom do
    it "should return events for specified date range, using end of day for end date" do
      timeframe = TimeFrame::Custom.new('06/01/2010', '06/15/2010')

      timeframe.start_date.should == DateTime.strptime('06/01/2010', '%m/%d/%Y')
      timeframe.end_date.should == DateTime.strptime('06/15/2010', '%m/%d/%Y').end_of_day
    end

    it "should default date range to this business week" do
      timeframe = TimeFrame::Custom.new(nil, nil)

      timeframe.start_date.should == @today.beginning_of_week
      timeframe.end_date.should == @today.end_of_week - 2.days
    end
  end

  describe TimeFrame::Hour do
    it "should use 1 hour interval starting from given hour" do
      timeframe = TimeFrame::Hour.new("06/01/2010 15:00")

      hour = DateTime.strptime('06/01/2010 15:00', '%m/%d/%Y %H:%M')
      timeframe.start_date.should == hour
      timeframe.end_date.should == (hour + 1.hour) - 1.second
    end
  end

  describe "parsing" do
    it "should parse today's timeframe" do
      TimeFrame.for('today', nil, nil, nil).should be_an_instance_of(TimeFrame::Today)
    end

    it "should parse tomorrow's timeframe" do
      TimeFrame.for('tomorrow', nil, nil, nil).should be_an_instance_of(TimeFrame::Tomorrow)
    end

    it "should parse this week's timeframe" do
      TimeFrame.for('this_week', nil, nil, nil).should be_an_instance_of(TimeFrame::ThisWeek)
    end

    it "should parse custom timeframe" do
      TimeFrame.for('custom', nil, nil, nil).should be_an_instance_of(TimeFrame::Custom)
    end

    it "should parse hour's timeframe" do
      TimeFrame.for('hour', nil, nil, '06/01/2010 15:00').should be_an_instance_of(TimeFrame::Hour)
    end
  end
end