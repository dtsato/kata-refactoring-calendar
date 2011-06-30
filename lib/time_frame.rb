class TimeFrame < Struct.new(:start_date, :end_date)

  def self.for(type, start_date, end_date, hour)
    case type
    when 'tomorrow'
      date = DateTime.now + 1
      TimeFrame.new(date.at_beginning_of_day, date.end_of_day)
    when 'this_week'
      TimeFrame.new(DateTime.now, (DateTime.now + 6 ).end_of_day)
    when 'custom'
      start_date = start_date.blank? ? DateTime.now.beginning_of_week : DateTime.strptime(start_date, '%m/%d/%Y')
      end_date = end_date.blank? ? (DateTime.now.end_of_week - 2) : DateTime.strptime(end_date, '%m/%d/%Y').end_of_day
      TimeFrame.new(start_date, end_date)
    when 'hour'
      start_date = DateTime.strptime(hour, '%m/%d/%Y %H:%M')
      end_date =  start_date + 1.hour-1.second
      TimeFrame.new(start_date, end_date)
    when 'today'
      date = DateTime.now
      TimeFrame.new(date.at_beginning_of_day, date.end_of_day)
    end
  end

end