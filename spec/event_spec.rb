require 'rspec'
require 'event'

describe Event do

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