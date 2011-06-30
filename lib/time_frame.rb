class TimeFrame
  attr_reader :start_date, :end_date

  class Today < TimeFrame
    def initialize
      date = DateTime.now
      @start_date, @end_date = date.at_beginning_of_day, date.end_of_day
    end
  end

  class Tomorrow < TimeFrame
    def initialize
      date = DateTime.now + 1
      @start_date, @end_date = date.at_beginning_of_day, date.end_of_day
    end
  end

  class ThisWeek < TimeFrame
    def initialize
      date = DateTime.now
      @start_date, @end_date = date, (date + 6.days ).end_of_day
    end
  end

  class Hour < TimeFrame
    def initialize(hour)
      hour = DateTime.strptime(hour, '%m/%d/%Y %H:%M')
      @start_date, @end_date = hour, (hour + 1.hour - 1.second)
    end
  end

  class Custom < TimeFrame
    def initialize(start_date, end_date)
      @start_date = start_date.blank? ? DateTime.now.beginning_of_week : DateTime.strptime(start_date, '%m/%d/%Y')
      @end_date = end_date.blank? ? (DateTime.now.end_of_week - 2) : DateTime.strptime(end_date, '%m/%d/%Y').end_of_day
    end
  end

  def self.for(type, start_date, end_date, hour)
    case type
    when 'tomorrow' then Tomorrow.new
    when 'this_week' then ThisWeek.new
    when 'custom' then Custom.new(start_date, end_date)
    when 'hour' then Hour.new(hour)
    when 'today' then Today.new
    end
  end

end