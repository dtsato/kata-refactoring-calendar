require 'database_helper'

class Event < ActiveRecord::Base
  named_scope :between_dates, lambda { |start_date, end_date|
    {:conditions => ["at >= ? AND at <= ?", start_date, end_date ] }
  }
  
  named_scope :between_hour_on_day, lambda { |start_hour|
    end_date =  start_hour + 1.hour-1.second
    { :conditions => {:at => start_hour..end_date} }
  }
  
  named_scope :between_day, lambda { |date|
    start_date = date.at_beginning_of_day
    end_date =  start_date.end_of_day
    { :conditions => {:at => start_date..end_date} }
  }
end